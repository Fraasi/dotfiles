// ==UserScript==
// @name         imdb-links
// @namespace    http://tampermonkey.net/
// @version      1.18.3
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
    const isMainPage = Boolean(document.querySelector('[data-testid="hero__pageTitle"]'))
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
      vidsrcLink.setAttribute('href', `https://vsrc.su/embed/${imdb_id}/${vidsrcEpisode}`)
      const movie_or_tv = isSeries ? 'tv' : 'movie'
      const primeEpisode = season ? `&season=${season}&episode=${selectedEpisode}` : ''
      primeSrcLink.setAttribute('href', `https://primesrc.me/embed/${movie_or_tv}?imdb=${imdb_id}&fallback=false&server_order=Vidmoly,PrimeVid,Mixdrop${primeEpisode}`)
      // const season_NUM = season ? Number(season) < 10 ? `0${season}` : season : ''
      // const episode_NUM = Number(selectedEpisode) < 10 ? `0${selectedEpisode}` : selectedEpisode
      // const extras = isEpisodePage ? `S${season_NUM}E${episode_NUM}` : year
      // const movieOrSeries = isEpisodePage ? 'series' : 'movie'
      // soaperLink.setAttribute('href', `https://soaper.live/search.html?keyword=${encodeURI(title)}`)
      const ytOver20min = '&sp=EgIYAg%253D%253D'
      ytLink.setAttribute('href', `https://www.youtube.com/results?search_query=${encodeURI(title + ' ' + year)}` + ytOver20min)
      okLink.setAttribute('href', 'https://ok.ru/video/showcase')
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
    const primeSrcLink = createLink('primeSrc')
    const ytLink = createLink('yt')
    const okLink = createLink('ok')
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
      const langs = [...document.querySelectorAll('[data-testid="title-details-languages"] > div > ul > li')].map(el => el.innerText)
      const langLink = createLink(`languages: ${langs.join(', ')}`)
      langLink.addEventListener('click', () => {
        document.querySelector('section[data-testid="Details"]').scrollIntoView()
      })
      wrapper.prepend(langLink)
    }

    // const br = document.createElement('br')
    wrapper.prepend(vidsrcLink, primeSrcLink, ytLink, okLink, archiveLink, '  -  ',
      episodesSpan, reviewsLink, ratingslink, soundtrackLink)

    document.addEventListener('keyup', (e) => {
      if (e.shiftKey && e.key === 'V') vidsrcLink.click()
      if (e.shiftKey && e.key === 'P') primeSrcLink.click()
      if (e.shiftKey && e.key === 'Y') ytLink.click()
      if (e.shiftKey && e.key === 'A') archiveLink.click()
      if (e.shiftKey && e.key === 'O') {
        navigator.clipboard.writeText(`${title} ${year}`)
        okLink.click()
      }
    })

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
        const job = e.target.innerText
        const hgroups = Array.from(document.querySelectorAll('hgroup'))
        const targetEl = hgroups.find( g => g. innerText === job)
        if (!targetEl) {
          console.log(targetEl)
          return
        }
        targetEl.scrollIntoView()
      })
    })
  }

  function hideElsButton() {
    const hideEls = 'TV Series|Music Video|Short|Video Game|Podcast Series'
    const hideButton = document.createElement('button')
    hideButton.innerText = `Hide ${hideEls} `
    hideButton.style.fontSize = '13px'
    const hideButton2 = hideButton.cloneNode(true)
    const hideButton3 = hideButton2.cloneNode(true)
    const regEx = new RegExp(hideEls)

    function onHideClick() {
      document.querySelectorAll('div.ipc-metadata-list-summary-item__c').forEach(e => {
        if (regEx.test(e.innerText)) e.parentNode.style.display = 'none'
      })
    }

    hideButton.addEventListener('click', onHideClick)
    hideButton2.addEventListener('click', onHideClick)
    hideButton3.addEventListener('click', onHideClick)
    const dirEl = document.querySelector('div.filmo-section-director')
    const actorEl = document.querySelector('div.filmo-section-actor')
    const actressEl = document.querySelector('div.filmo-section-actress')
    dirEl ? dirEl.append(hideButton) : null
    actorEl ? actorEl.append(hideButton2) : null
    actressEl ? actressEl.append(hideButton3) : null
  }

  const url = document.URL
  if (url.includes('/title/')) showLinks()
  if (url.includes('/find/')) hidePodcasts()
  if (url.includes('/name/')) {
    linkJobs()
    hideElsButton()
  }

})();

