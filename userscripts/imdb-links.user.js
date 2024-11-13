// ==UserScript==
// @name         imdb-links
// @namespace    http://tampermonkey.net/
// @version      1.10.1
// @description  Reverse some enshittification from imdb & add some useful links
// @author       Fraasi
// @match        https://www.imdb.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=imdb.com
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function () {
  'use strict';

  function showLinks() {
    const docTitle = document.title
    const imdb_id = window.location.pathname.match(/tt\d+/)[0]
    const title = docTitle.split(/ \(| - /)[0].trim()
    const isMainPage = Boolean(document.querySelector('.titlereference-section-overview'))
    const isEpisodePage = window.location.pathname.includes('episodes')
    const year = docTitle.match(/\d{4}/)?.[0] || ''
    const isSeries = /TV( Mini)? Series|Season/.test(docTitle)
    let episodeCount = isEpisodePage ? document.querySelectorAll('.episode-item-wrapper').length : 0
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

      const season = isEpisodePage ? document.querySelector('.ipc-tabs--display-chip .ipc-tab--active').innerText : ''
      const vidsrcEpisode = season ? season + '-' + selectedEpisode : ''
      vidsrcLink.setAttribute('href', `https://vidsrc.me/embed/${imdb_id}/${vidsrcEpisode}`)

      const season_NUM = season ? Number(season) < 10 ? `0${season}` : season : ''
      const episode_NUM = Number(selectedEpisode) < 10 ? `0${selectedEpisode}` : selectedEpisode
      const extras = isEpisodePage ? `S${season_NUM}E${episode_NUM}` : year
      const movieOrSeries = isEpisodePage ? 'series' : 'movie'
      movieWebLink.setAttribute('href', `https://vidbinge.com/browse/${encodeURI(title)}`)
      // upmovies server breaks if search starts with 'the '
      const upTitle = title.replace(/^The\s/, '')
      const upMoviesSearch = isEpisodePage ? `${upTitle}+season+${season}` : `${upTitle} ${year}`.replaceAll(' ', '+')
      upMoviesLink.setAttribute('href', `https://upmovies.net/search-movies/${encodeURI(upMoviesSearch)}.html`)
      soaperLink.setAttribute('href', `https://soaper.live/search.html?keyword=${encodeURI(title)}`)
      const ytOver20min = '&sp=EgIYAg%253D%253D'
      ytLink.setAttribute('href', `https://www.youtube.com/results?search_query=${encodeURI(title + ' ' + year)}` + ytOver20min)
      archiveLink.setAttribute('href', `https://archive.org/search?query=title%3A%28${encodeURI(title)}%29+AND+mediatype%3A%28movies%29`)
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
    const movieWebLink = createLink('vidbinge')
    const upMoviesLink = createLink('upMovies')
    const soaperLink = createLink('soaper')
    const ytLink = createLink('yt')
    const archiveLink = createLink('archive')
    const episodesSpan = createLink('', 'span')
    const reviewsLink = createLink('reviews')
    reviewsLink.setAttribute('href', `https://www.imdb.com/title/${imdb_id}/reviews`)
    reviewsLink.setAttribute('target', '')
    const ratingslink = createLink('ratings')
    ratingslink.setAttribute('href', `https://www.imdb.com/title/${imdb_id}/ratings`)
    ratingslink.setAttribute('target', '')
    const soundtrackLink = createLink('soundtracks')
    soundtrackLink.setAttribute('href', `https://www.imdb.com/title/${imdb_id}/soundtrack`)
    soundtrackLink.setAttribute('target', '')
    const separator = createLink(' - ', 'span')

    if (isSeries) {
      const nextEpLink = createLink('next-episode')
      nextEpLink.setAttribute('href', `https://next-episode.net/search/?name=${title}`)
      nextEpLink.style.display = 'block'
      nextEpLink.style.position = 'fixed'
      nextEpLink.style.top = `${window.innerHeight - 40}px`
      nextEpLink.style.right = '6px'
      nextEpLink.style.height = '20px'
      document.body.prepend(nextEpLink)
    }

    const wrapper = document.querySelector('main.ipc-page-wrapper') || document.querySelector('#wrapper')
    wrapper.style.background = 'rgb(18, 18, 18)'

    if (isMainPage) {
      const langs = [...document.querySelectorAll('[href^="/language"]')].map(el => el.href.split('/').pop()).join(' / ')
      const langLink = createLink(`languages: ${langs}`)
      wrapper.prepend(langLink)
    }

    wrapper.prepend(vidsrcLink, movieWebLink, upMoviesLink, soaperLink, ytLink, archiveLink, episodesSpan, separator, reviewsLink, ratingslink, soundtrackLink)

    update()

    if (isEpisodePage) {
      function getNewData(mutationsList, observer) {
        for (const mutation of mutationsList) {
          if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
            selectedEpisode = 1
            episodeCount = isEpisodePage ? document.querySelectorAll('.episode-item-wrapper').length : 0
            update()
          }
        }
      };
      const observer = new MutationObserver(getNewData)
      observer.observe(
        document.querySelector('.ipc-page-section.ipc-page-section--base.ipc-page-section--sp-pageMargin:nth-child(2)'),
        { childList: true, subtree: true }
      )
    }
  }

  function hidePodcasts() {
    const findSummarys = document.querySelectorAll('.ipc-metadata-list-summary-item.ipc-metadata-list-summary-item--click.find-result-item.find-title-result')
    findSummarys.forEach(s => {
      if (s.innerText.includes('Podcast')) s.style.display = 'none'
    })
  }

  /**
   * Iterates through all job links and adds event listeners to scroll to corresponding section on click.
   */
  function linkJobs() {
    document.querySelectorAll('h1+ul.ipc-inline-list > li').forEach( (el, i) => {
      el.classList.add('ipc-chip', 'ipc-chip--on-base-accent2')
      el.addEventListener('click', (e) => {
        const job = e.target.innerText.toLowerCase()
        const targetEl = document.getElementsByClassName(`filmo-section-${job}`)[0]
        if (!targetEl) {
          console.log(targetEl)
          return
        }
        targetEl.scrollIntoView()
        const targetUpcoming = document.querySelector(`#${job}-upcoming-projects`)
        const targetPrevious = document.querySelector(`#${job}-previous-projects`)
        if ( targetUpcoming && targetUpcoming.classList.contains('ipc-accordion__item--collapsed') ) targetUpcoming.classList.replace('ipc-accordion__item--collapsed', 'ipc-accordion__item--expanded')
        if ( targetPrevious && targetPrevious.classList.contains('ipc-accordion__item--collapsed') ) targetPrevious.classList.replace('ipc-accordion__item--collapsed', 'ipc-accordion__item--expanded')

      })
    })
  }

  function hideElsButton() {
    const hideButton = document.createElement('button')
    hideButton.innerText = 'Hide tv-series | shorts | music vids'
    hideButton.style.fontSize = '13px'

    hideButton.addEventListener('click', () => {
      document.querySelectorAll('div.ipc-metadata-list-summary-item__c').forEach(e => {
        if (/TV Series|Music Video|Short/.test(e.innerText)) e.parentNode.style.display = 'none'
      })
    })
    const dirEl = document.querySelector('div.filmo-section-director')
    dirEl.append(hideButton)
  }

  const url = document.URL
  if (url.includes('/title/')) showLinks()
  if (url.includes('/find/')) hidePodcasts()
  if (url.includes('/name/')) {
    linkJobs()
    hideElsButton()
  }

})();
