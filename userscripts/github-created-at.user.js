// ==UserScript==
// @name        GitHub created at
// @version     0.1.0
// @description Alert popup to view repo created at - time and size
// @license     MIT
// @author      Fraasi
// @namespace   https://github.com/Fraasi
// @match       https://github.com/*
// @run-at      document-idle
// @grant       none
// @icon        https://github.githubassets.com/pinned-octocat.svg
// ==/UserScript==


(function () {
  'use strict';

  const BADGE_CLASS = 'createdAt';
  const SELECTOR = `.${BADGE_CLASS}`;

  function formatBytes(bytes, decimals = 2) {
    if (bytes === 0) return '0 Bytes';
    const units = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    const i = Math.floor(Math.log(bytes) / Math.log(1024));
    return `${parseFloat((bytes / Math.pow(1024, i)).toFixed(decimals))} ${units[i]}`;
  }

  function buildBadge() {
    const span = document.createElement('span');
    span.className = `Label Label--secondary v-align-middle mr-1 ${BADGE_CLASS}`;
    span.innerText = 'Created at';
    span.style.cursor = 'pointer';
    span.title = 'Show repo creation date and size';
    span.addEventListener('click', onBadgeClick);
    return span;
  }

  async function onBadgeClick() {
    const parts = window.location.pathname.split('/').filter(Boolean);
    if (parts.length < 2) {
      alert('Not in a repository page.');
      return;
    }
    const repoPath = parts.join('/');

    try {
      const json = await fetch(`https://api.github.com/repos/${repoPath}`).then(r => r.json());
      if (json.message) {
        alert(`API error: ${json.message}`);
        return;
      }
      alert(
        `${repoPath}\n\n` +
        `Created: ${new Date(json.created_at).toLocaleString('en-GB')}\n\n` +
        `Size: ${formatBytes(json.size * 1024)}`
      );
    } catch (e) {
      alert(`${e.message}.\nSee console for more info.`);
    }
  }

  function ensureBadge() {
    const wrapper = document.querySelector('div#repo-title-component > div');
    if (!wrapper) return;

    const existing = document.querySelector(SELECTOR);
    if (existing && wrapper.contains(existing)) return; // already attached

    if (existing) existing.remove();
    wrapper.append(buildBadge());
  }

  // GitHub re-renders the repo header via React, which wipes the badge.
  // Watch for DOM changes and re-attach whenever needed.
  const observer = new MutationObserver(() => ensureBadge());
  observer.observe(document.documentElement, { childList: true, subtree: true });

  ensureBadge(); // in case the header already exists

})();

