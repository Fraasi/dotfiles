// ==UserScript==
// @name         imdb-links
// @namespace    http://tampermonkey.net/
// @version      0.5
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
  const isMainPage = Boolean(document.querySelector('.titlereference-section-overview'))
  const isEpisodePage = window.location.pathname.includes('episodes')
  const year = docTitle.match(/\d{4}/)?.[0] || ''
  // const isSeries = /TV Series|Season/.test(docTitle)
  let episodeCount = isEpisodePage ? document.querySelectorAll('.list_item').length : 0
  let selectedEpisode = 1

  function createLink(text, el = 'a') {
    const styles = `
    z-index: 5;
    position: sticky;
    top: 5px;
    margin-left: 5px;
    padding: 0px 5px;
    text-decoration: none;
    font-size: 16px;
    font-weight: bold;
    color: #ddd;
    border-radius: 4px;
    border: 1px solid black;
    box-shadow: #2080cb 0px 1px 2px 0px;
    background-color: #121212;`

    const elem = document.createElement(el)
    elem.setAttribute('target', '_blank')
    elem.innerText = text
    elem.style = styles
    return elem
  }

  function update() {

    const season = isEpisodePage ? document.querySelector('#bySeason option[selected="selected"]').value : ''
    const vidsrcEpisode = season ? season + '-' + selectedEpisode : ''
    vidsrcLink.setAttribute('href', `https://vidsrc.me/embed/${imdb_id}/${vidsrcEpisode}`)

    const watchfilmSearchTitle = title.toLowerCase().replaceAll(' ', '-')
    const watchfilmSearchString = `${watchfilmSearchTitle}-${year}`
    watchfilmLink.setAttribute('href', `https://ww22.watchfilm.net/search//${watchfilmSearchString}`)

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

  const vidsrcLink = createLink('vidsrc')
  const watchfilmLink = createLink('watchfilm')
  const crocovidLink = createLink('crocovid')
  const episodesSpan = createLink('', 'span')
  const soundtrackLink = createLink('soundtracks')
  soundtrackLink.setAttribute('href', `https://www.imdb.com/title/${imdb_id}/soundtrack`)
  soundtrackLink.setAttribute('target', '')
  const wrapper = document.querySelector('main.ipc-page-wrapper') || document.querySelector('#wrapper')

  wrapper.style.background = 'rgb(18, 18, 18)'

  if (isMainPage) {
    const langs = [...document.querySelectorAll('[href^="/language"]')].map(el => el.href.split('/').pop()).join(' / ')
    const langLink = createLink(`languages: ${langs}`)
    wrapper.prepend(langLink)
  }

  wrapper.prepend(vidsrcLink, watchfilmLink, crocovidLink, episodesSpan, soundtrackLink)

  update()

  if (isEpisodePage) {
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
  }

})();
