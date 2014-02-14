puhsh
=====
puhsh is the official repo for the application at www.puhsh.com. Before we get started, here is a high level explanation of what makes puhsh.com run:

#### Code
* Rails 3.2
* Ruby 2.0.0
* RVM

#### Front End
* Sass, .scss syntax
* Compass
* JavaScript
* Bower managed dependencies
* Foundation

#### Web Server
* pow (for development)
* nginx
* unicorn (production)

#### Database and other data stores
* MySQL 5.6.13
* Redis 2.8.0
* S3

#### Ops
* Hosted on SoftLayer
* Infrastructure managed with Chef. See [puhsh/puhsh-chef](https://github.com/puhsh/puhsh-chef)
* Deployments trigger by Jenkins after successful tests.


## Getting the app running locally

## Step 1: Bower
[Bower](http://bower.io/) is a front end package manager. It is built on node.js. You will need to use it in order to work on the front end of puhsh. To install:

1. Download and install the latest version of node.js 
2. `npm install -g bower` 

Boom. Bower is now installed.

## Step 2: Ruby on Rails

1. Install the necessary tools (ideally the ones mentioned above)
2. Clone the repo down
3. `bundle install`
4. `rake bower:install`
5. `rake db:create`
6. `rake db:test:prepare`
7. `rake db:schema:load`
8. `rake db:seed`
9. `guard init rspec`


## Step 3: Angular JS
Our front end is managed by AngularJS and it comes with its own set of specs and goodies.  Here is what you need to do to get started on the Angular side of things (get your node.js on):

1. `npm install -g karma@canary phantomjs karma-phantomjs-launcher`
2. `npm install -g karma`
3. `karma run` and watch all the specs pass.
4. `karma start` will automatically run specs as you make changes. This is optional.

Just like rspec tests, Jasmine Specs will get run on every deploy as well.


Great succes. You are now ready to start working.

### Contributing
Now that you have the app ready to go, you can head over to the [contributing](CONTRIBUTING.md) guide.
