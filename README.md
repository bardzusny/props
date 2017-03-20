# Props
[![](http://img.shields.io/codeclimate/github/netguru/props.svg?style=flat-square)](https://codeclimate.com/github/netguru/props)
[![](http://img.shields.io/codeclimate/coverage/github/netguru/props.svg?style=flat-square)](https://codeclimate.com/github/netguru/props)
[![](http://img.shields.io/gemnasium/netguru/props.svg?style=flat-square)](https://gemnasium.com/netguru/props)

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/netguru/props/tree/master)

## General info

This app is called **PROPS**. The idea behind it is to express saying 'thank you!'
in a geeky way.

## Technologies

* Ruby on Rails 4.2
* Ruby 2.2.3
* Postgres
* React with [react_webpack_rails](https://github.com/netguru/react_webpack_rails)

## Setup

Copy database settings:

```
cp config/database.yml.sample config/database.yml
```

Create DB user:

```
createuser -s -r props
```

Setup database:

```
bin/rake db:setup
```

Setup config file for your environment:

```
cp config/secrets.yml.sample config/secrets.yml
```

Generate omniauth credentials for your application by going to [Google Developer
Console](https://code.google.com/apis/console) and creating new project there.

Development endpoints:

- http://props.dev
- http://props.dev/auth/google_oauth2/callback

When you have the credentials, put them in the `config/secrets.yml` file
under `omniauth_provider_key` and `omniauth_provider_secret` values.

Auth0 integration:

1. Create `non-interactive auth0 client` and use `AUTH0_API_CLIENT_ID` and `AUTH0_API_CLIENT_SECRET` from that client
2. Go to your auth0 account settings, advanced tab, and turn on 'Enable APIs Section' for be able to see API's view
3. Under API section, create click button for creating api and after that you will receive `AUTH0_API_AUDIENCE` 
4. Don't forget to connect and authorise api in Auth0 Management API (non-interactive-clients tab), with your new ni-client, created in point 1

Slack feature:

In order to post props notifications and recieve thumbs-ups, you need to create a new Bot Integration and put its API token under `slack.token` in your secrets. Besides token, please provide `slack.default_channel` value (must be valid channel name, e.g. `general`).

_Note: If you're going to use Heroku Free Dynos, please be aware that you app will sleep at least 6h a day - and because of that you may not receive all reactions from Slack._

Install node dependencies:
```
$ npm install
```

Generate react-bundle for the first time:

```
$ npm build
```

## Development
* run rails server.
* run webpack in watch mode:
  ```
  $ npm start
  ```

## Tests

We use RSpec 3 for testing backend and Mocha + Karma to test React components.
We are using Chrome launcher.

### Running components test:

* run `npm run test-dev` to run tests.
* run `npm run test-live` to run tests in watch mode.

## Notes

Please follow Ruby style guide available [here](https://github.com/bbatsov/ruby-style-guide).

## Contributing

If you make improvements to this application, please share with others.

* Fork the project on GitHub.
* Make your feature addition or bug fix.
* Commit with Git.
* Send the author a pull request.

If you add functionality to this application, create an alternative
implementation, or build an application that is similar, please contact
me and I’ll add a note to the README so that others can find your work.

## License

MIT. See [LICENSE](LICENSE).
