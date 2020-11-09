#!/usr/bin/env node

const https = require('https')

const userName = process.argv[2] || process.env.USERNAME.replace(/\./g,'').toLowerCase()
const URI = `https://api.github.com/users/${userName}/repos?per_page=100`

https.get(URI, { headers: {'user-agent': userName} }, (response) => {

  let data = ''
  response.on('data', (chunk) => { data += chunk })

  response.on('end', () => {
		const jayson = JSON.parse(data)
		const result = jayson.reduce((res, repo) => {
			if (
				!repo.fork
				&& (repo.stargazers_count > 0
					|| repo.watchers_count > 0
					|| repo.forks > 0
					|| repo.open_issues > 0)
				) {
				res.push({
					name: repo.name,
					html_url: repo.html_url,
					stargazers_count: repo.stargazers_count,
					watchers_count: repo.watchers_count,
					forks: repo.forks,
					open_issues: repo.open_issues
				})
			}
			return res
		}, [])
		console.log('result:', result)
  })

}).on("error", (err) => {
		console.log("Error: " + err.message)
})
