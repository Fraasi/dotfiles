### Instructions for local userscript developement in Tampermonkey

* install a proxy script with @require tag
```js
// ==UserScript==
// ... whatever ...
// @require    http://localhost:5500/script.user.js
// ==/UserScript==
```
* Make sure `Externals	
Update Interval:` is set to `always` in the settings
* Run `live server`in vsCode, or something like `python -m http.server 5500` in the terminal and vim to edit the script
* No need to update version or click script update in tampermonkey while developing, but two page reloads is needed:

> Actually it requires 2 reloads for each change to take effect on the page. The first reload trigger the update of external script but without execution (it runs the legacy version of the script), the second reload will start to run the updated script.

* Need live-reload or build step? Maybe use [webpack-userscript](https://github.com/momocow/webpack-userscript?tab=readme-ov-file#webpack-userscript)

