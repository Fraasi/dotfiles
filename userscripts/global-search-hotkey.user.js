// ==UserScript==
// @name         Global search focus hotkey
// @namespace    https://github.com/fraasi
// @version      0.1
// @description  hotkey to focus search input on any page
// @author       Fraasi
// @match        *://*/*
// @grant        none
// ==/UserScript==

(function () {
  'use strict';
  document.addEventListener('keydown', (e => {
    if (e.ctrlKey && e.key === '<') {
      const inputs = document.querySelectorAll('input')
      for (let i = 0; i < inputs.length; i++) {
        if (inputs[i].type === 'search') {
          inputs[i].focus()
          break
        } else if (inputs[i].type === 'text') {
          const attrs = inputs[i].attributes
          for (let a = 0; a < attrs.length; a++) {
            if (attrs[a].value.toLowerCase().includes('search' || attrs[a].value.toLowerCase().includes('enter'))) {
              inputs[i].focus()
              break
            }
          }
        }
      }
    }
  }))
})();
