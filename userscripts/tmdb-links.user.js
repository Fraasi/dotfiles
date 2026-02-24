// ==UserScript==
// @name         tmdb-links
// @namespace    http://tampermonkey.net/
// @version      1.0.1
// @description  add some streaming links to tmdb
// @author       Fraasi
// @match        https://www.themoviedb.org/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=themoviedb.org
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function () {
  'use strict';

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

  function showLinks() {
    const pathName = window.location.pathname
    const tmdb_id = pathName.match(/\/(\d+)-/)[1]
    const titleEl = document.querySelector('section.header h2')
    const title = titleEl.querySelector('a').innerText
    const year = titleEl.querySelector('.release_date').innerText.replaceAll(/\(|\)/g, '')
    const isSeries = /tv/.test(pathName)
    const isEpisodePage = pathName.includes('season')
    let episodeCount = isEpisodePage ? document.querySelector('h3.episode_sort.space > span').innerText : 0
    let selectedEpisode = 1

    function update() {

      const season = isEpisodePage ? pathName.split('/').pop() : ''
      const vidsrcEpisode = season ? season + '-' + selectedEpisode : ''
      vidsrcLink.setAttribute('href', `https://vidsrc.me/embed/${tmdb_id}/${vidsrcEpisode}`)
      const movieOrTv = isSeries ? 'tv' : 'movie'
      const primeEpisode = season ? `&season=${season}&episode=${selectedEpisode}` : ''
      primeSrcLink.setAttribute('href', `https://primesrc.me/embed/${movieOrTv}?tmdb=${tmdb_id}&fallback=false&server_order=Vidmoly,PrimeVid,Mixdrop${primeEpisode}`)

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

    const wrapper = document.querySelector('div#shortcut_bar_scroller')
    wrapper.style.background = 'rgb(18, 18, 18)'
    wrapper.after(vidsrcLink, primeSrcLink, ytLink, okLink, archiveLink, '  -  ', episodesSpan)

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

  }

  function hideElsButton() {
    const hideEls = 'Self'
    // const hideButton = document.createElement('button')
    const hideButton = createLink(`Hide ${hideEls} `, 'button')

    // hideButton.innerText = `Hide ${hideEls} `
    hideButton.style.fontSize = '13px'
    const regEx = new RegExp(hideEls)
    const table = document.querySelector('section.credits table')

    function onHideClick() {
      table.querySelectorAll('tr').forEach(tr => {
        const char = tr.querySelector('span.character')
        if (char !== null) {
          if (regEx.test(char.innerText)) tr.style.display = 'none'
        }
      })
    }

    hideButton.addEventListener('click', onHideClick)

    table.prepend(hideButton)
  }

  const regex = /tv|movie/
  const pathName = window.location.pathname
  if (regex.test(pathName)) showLinks()
  if (pathName.includes('/person/')) hideElsButton()

})();

