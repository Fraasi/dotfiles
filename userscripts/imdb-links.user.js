// ==UserScript==
// @name         imdb-links
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Add video links to imdb pages
// @author       Fraasi
// @match        https://www.imdb.com/title/tt*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=imdb.com
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function () {
  'use strict';

  const docTitle = document.title
  const imdb_id = window.location.pathname.match(/tt\d+/)[0]
  const title = docTitle.split(/ \(| - /)[0].trim()
  const isEpisodePage = window.location.pathname.includes('episodes')
  const year = isEpisodePage ? '' : docTitle.match(/\d{4}/)[0]
  const isSeries = /TV Series|Season/.test(docTitle)
  let episodeCount = isEpisodePage ? document.querySelectorAll('.list_item').length : 0
  let selectedEpisode = 1

  function createLink(text, bgColor, el = 'a') {
    const styles = `
      z-index: 1;
      position: sticky;
      top: 5px;
      margin-left: 5px;
      padding: 0px 5px;
      text-decoration: none;
      font-size: 16px;
      font-weight: bold;
      color: whitesmoke;
      border-radius: 4px;
      border: 1px solid black;
      box-shadow: 0px 3px 5px 2px #605084;
      background-color: ${bgColor};`

    const elem = document.createElement(el)
    elem.setAttribute('target', '_blank')
    elem.innerText = text
    elem.style = styles
    return elem
  }

  const vidsrcLink = createLink('vidsrc', '#e600e6')
  const putlockerLink = createLink('putlocker', '#46920e')
  const crocovidLink = createLink('crocovid', '#7aae28')
  const episodesSpan = createLink('', '#1f1f1f', 'span')

  function update() {

    const season = isEpisodePage ? document.querySelector('#bySeason option[selected="selected"]').value : ''
    const vidsrcEpisode = season ? season + '-' + selectedEpisode : ''
    vidsrcLink.setAttribute('href', `https://vidsrc.me/embed/${imdb_id}/${vidsrcEpisode}`)

    const putSearchTitle = title.toLowerCase().replaceAll(' ', '+')
    const putSearchString = isEpisodePage ? `${putSearchTitle}+season+${season}` : putSearchTitle
    putlockerLink.setAttribute('href', `https://putlockers.gs/search-movies/${putSearchString}.html`)

    const season_NUM = season ? Number(season) < 10 ? `0${season}` : season : ''
    const episode_NUM = Number(selectedEpisode) < 10 ? `0${selectedEpisode}` : selectedEpisode
    const crocoExtras = isEpisodePage ? `S${season_NUM}E${episode_NUM}` : year
    crocovidLink.setAttribute('href', `https://crocovid.com/?q=${title} ${crocoExtras}`)

    let epHTML = ''
    if (isEpisodePage) {
      let options = ''
      for (let i = 0; i < episodeCount; i++) {
        options += `<option value="${i + 1}" ${(i + 1) === selectedEpisode ? 'selected' : ''}>${i + 1}</option>`
      }
      epHTML = `
        <label for="episodes">${episodeCount} episodes</label>
        <select name="episodes" id="select-episode">
          ${options}
        </select>`

        episodesSpan.innerHTML = epHTML
        document.getElementById("select-episode").onchange = function (evt) {
          selectedEpisode = Number(evt.target.value)
          update()
        }
    } else {
      episodesSpan.style = 'display: none;'
    }
  }

  document.querySelector('#wrapper').prepend(vidsrcLink, putlockerLink, crocovidLink, episodesSpan)
  update()

  function getNewData(mutationsList, observer) {
    for (const mutation of mutationsList) {
      if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
        selectedEpisode = 1
        episodeCount = isEpisodePage ? document.querySelectorAll('.list_item').length : 0
        update()
      }
    }
  };
  const observer = new MutationObserver(getNewData)
  observer.observe(document.querySelector('#episodes_content'), { childList: true })

})();
