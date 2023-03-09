### Some useful bookmarklets I´ve found/written

You can use these in Vivaldi as 'command chains'
* put `Open link in current tab` in command 1
* put code to `command parameter` section
* 'customize toolbar', select command chains and drag & drop your commands icon to where you want it  

Dark mode (invert)
```js
javascript:(d=>{const css=`:root{background-color:#fefefe;filter:invert(100%)}*{background-color:inherit}img:not([src*=".svg"]),video{filter: invert(100%)}`,style,id="dark-theme-snippet",ee=d.getElementById(id);if(null!=ee){ee.parentNode.removeChild(ee)}else{style=d.createElement('style');style.type="text/css";style.id=id;if(style.styleSheet){style.styleSheet.cssText=css}else{style.appendChild(d.createTextNode(css))}(d.head||d.querySelector('head')).appendChild(style)}setTimeout(()=>{const t=window.location.href;window.history.replaceState("stateObj","",t)},300)})(document);
```

Jump to next heading in page (h1-h4)
```js
javascript:(d => { let header = d.querySelector('header').getBoundingClientRect().height || 0; let heading = [...document.querySelectorAll('h1,h2,h3,h4')].find(el => { return el.getBoundingClientRect().top > 300 }); scrollTo({ behavior: "smooth", top: heading.offsetTop - header });})(document);
```

Linkify, make hashlinks to all headings containing id, to easily bookmark to that part
```js
javascript:(d => { d.querySelectorAll('h1[id], h2[id], h3[id]').forEach(el => { const l = d.createElement('a'); l.innerText = '🔗';  l.setAttribute('href', `#${el.id}`); el.prepend(l); });})(document);
```
