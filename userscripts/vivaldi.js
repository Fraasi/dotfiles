// quick commands

// linktotext
javascript:(function(){const selectedText=getSelection().toString();const newUrl=new URL(location);newUrl.hash=`:~:text=${encodeURIComponent(selectedText)}`;window.open(newUrl, '_self');})();

// next heading
javascript:(d => { let header = d.querySelector('header').getBoundingClientRect().height || 0; let heading = [...document.querySelectorAll('h1,h2,h3,h4')].find(el => { return el.getBoundingClientRect().top > 300 }); scrollTo({ behavior: "smooth", top: heading.offsetTop - header });})(document);

// dark (invert)
javascript:(d=>{var css=`:root{background-color:#fefefe;filter:invert(100%)}*{background-color:inherit}img:not([src*=".svg"]),video{filter: invert(100%)}`,style,id="dark-theme-snippet",ee=d.getElementById(id);if(null!=ee){ee.parentNode.removeChild(ee)}else{style=d.createElement('style');style.type="text/css";style.id=id;if(style.styleSheet){style.styleSheet.cssText=css}else{style.appendChild(d.createTextNode(css))}(d.head||d.querySelector('head')).appendChild(style)}setTimeout(()=>{const t=window.location.href;window.history.replaceState("stateObj","",t)},300)})(document);^

//
