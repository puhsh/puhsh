puhsh
=====
puhsh is the official repo for the application at www.puhsh.com. Before we get started, here is a high level explanation of what makes puhsh.com run:

#### Code
* Rails 4.1
* Ruby 2.1.2
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


## Running puhsh locally

### Step 1: Bower
[Bower](http://bower.io/) is a front end package manager. It is built on node.js. You will need to use it in order to work on the front end of puhsh. To install:

1. Download and install the latest version of node.js 
2. `npm install -g bower` 

### Step 2: Ruby on Rails

Standard stuff here.

1. Install the necessary tools (ideally the ones mentioned above)
2. Clone the repo down
3. `cp config/database.example.yml config/database.yml`
4. `bundle install`
5. `rake bower:install`
6. `rake db:create`
7. `rake db:test:prepare`
8. `rake db:schema:load`
9. `rake db:seed`
10. `guard init rspec`
11. (Optional) If you would like more cities in your database, checkout `cities.rake`. Execute each rake task in order to populate your city database.

### Great succes. You are now ready to start working.

### Contributing
Now that you have the app ready to go, you can head over to the [contributing](CONTRIBUTING.md) guide.
