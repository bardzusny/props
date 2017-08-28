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
* Ruby 2.3.1
* Postgres
* React with [react_webpack_rails](https://github.com/netguru/react_webpack_rails)

## Setup

```
bin/setup
```

Create slack application by going to [Your Apps](https://api.slack.com/apps).
It is important to set the redirect url for your application to be like `https://yourdomain/auth/slack/callback`.
You'll also need to select Permission Scopes to be as follows:

- identity.avatar
- identity.basic
- identity.email
- identity.team
- chat:write:bot
- team:read
- users.profile:read
- users:read
- users:read.email


Development endpoints:

- http://props.dev
- http://props.dev/auth/slack/callback

When you have the credentials, you need to set up the proper variables in the .env file under `SLACK_CLIENT_ID` and `SLACK_CLIENT_SECRET` values.

Slack feature:

In order to post kudos notifications and recieve thumbs-ups, you need to set slack channel for your organisation in Settings after signing in. If not set, default Slack channel is `general`.

After creating the slash command, you will be provided with the verification token by Slack. In order to verify that requests are actually coming from Slack add the token to the database. In the console run:
```
EasyTokens::Token.create(value: 'VERIFICATION_TOKEN', description: 'Slack command verification token')
```

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
