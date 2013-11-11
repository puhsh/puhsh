puhsh
=====
puhsh is the official repo for the application at www.puhsh.com. Before we get started, here is a high level explanation of what makes puhsh.com run:

#### Code
* Rails 3.2.14
* Ruby 1.9.3
* RVM

#### Front End
* Sass, .scss syntax
* Compass
* JavaScript

#### Web Server
* pow (for development)
* nginx
* unicorn (production)

#### Database and other data stores
* MySQL 5.6.13

#### Ops
* Hosted on SoftLayer
* Infrastructure managed with Chef. See [puhsh/puhsh-chef](https://github.com/puhsh/puhsh-chef)
* Deployments trigger by Jenkins after successful tests.


### Enough of the boring crap! I want to start working!

1. Install the necessary tools (Rails, RVM, Pow, etc)
2. Clone the repo down
3. `rake db:create`
4. `rake db:test:prepare`
5. `rake db:schema:load`
6. `rake db:seed`

Great succes. You are now ready to start working.

### Contributing

Now that you have the app ready to go, you can head over to the [contributing](github.com/puhsh/puhsh/blob/master/CONTRIBUTING.MD) guide.
