#!/usr/bin/env node

// piping works when this file is in $PATH. eg. '$ gh-repos.js | grep dotfiles'

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
		console.log('repos:', result)
  })

}).on("error", (err) => {
		console.log("Error: " + err.message)
})
