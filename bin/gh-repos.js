#!/usr/bin/env node
// have to be Node.exe for bash piping to work
// for piping to work eg. ./gh-repos.js | grep dotfiles
// just run '$ bash' before executing
// see below to rubbleshoot--
// https://nodejs.org/api/tty.html#tty_tty


const https = require('https')

const userName = process.argv[2] || process.env.USERNAME.replace(/\./g,'').toLowerCase()
const URI = `https://api.github.com/users/${userName}/repos?per_page=100`

https.get(URI, { headers: {'user-agent': userName} }, (response) => {

  let data = ''
  response.on('data', (chunk) => { data += chunk })

  response.on('end', () => {
		const jayson = JSON.parse(data)
		const result = jayson.reduce((res, repo) => {
			if ( !repo.fork ) {
				res.push({
					name: repo.name,
					html_url: repo.html_url,
				})
			}
			return res
		}, [])
		console.log('result:', result)
  })

}).on("error", (err) => {
		console.log("Error: " + err.message)
})
