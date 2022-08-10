// ==UserScript==
// @name        GitHub created at
// @version     0.0.1
// @description Alert popup to view repo created at - time and size
// @license     MIT
// @author      Fraasi
// @namespace   https://github.com/Fraasi
// @match       https://github.com/*
// @run-at      document-start
// @grant       none
// @icon        https://github.githubassets.com/pinned-octocat.svg
// ==/UserScript==


(function () {
  'use strict';

  function formatBytes(a, b) {
    if (0 == a) return "0 Bytes";
    const c = 1024;
    const d = b || 2;
    const e = ["Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    const f = Math.floor(Math.log(a) / Math.log(c));
    return parseFloat((a / Math.pow(c, f)).toFixed(d)) + " " + e[f];
  }

  function init() {
    if (document.querySelector('.createdAt')) return;
    const span = document.createElement('span');
    span.className = 'Label Label--secondary v-align-middle mr-1 createdAt';
    span.innerText = 'Created at';
    span.style.cursor = 'pointer';
    span.onclick = function () {
      if (window.location.pathname.split('/').length < 3) {
        alert('Not in a repository page.');
        return;
      }
      const cleanRepoName = window.location.pathname.split('/').splice(0, 3).join('/');
      fetch(`https://api.github.com/repos${cleanRepoName}`)
        .then(data => data.json())
        .then(json => {
          console.log('Github repo alert json', json);
          alert(`${cleanRepoName}\n\nCreated: ${new Date(json.created_at).toLocaleString('EN-GB')}\n\nSize: ${formatBytes(json.size * 1024)}`)
        }).catch(e => alert(`${e.message}.\nSee console for more info.`));
    };

    const wrapper = document.querySelector('div.d-flex.flex-wrap.flex-items-center.wb-break-word.f3.text-normal');
    wrapper.append(span);
  }

  document.addEventListener('soft-nav:success', e => {
    init()
  })
  document.addEventListener('DOMContentLoaded', e => {
    init()
  })

})();
