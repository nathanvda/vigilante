# Vigilante
========

Vigilante is a plugin that will offer database stored authorisation, and offers the ability
that certain permissions have a limited scope/extent.

All permissions can be managed from an admin-interface.
If permissions are changed, they will be used on the next login.

## Terminology

- context: the current context, the object(s) we want to see/visit
- scope  : term from activerecord, to allow scoping a query (adding conditions).
- extent : permissions have an extent; permissions are only valid in a certain context.

## Example

Suppose we have a site like blogger -> multiple blogs, a blog can have multiple author, a blog can have limited access.

So we have something like

    class User
      has_many :posts
    end

    class Post
      belongs_to :author, :class_name => User
      belongs_to :blog
    end

    class Comment
      belongs_to :post
      belongs_to :commentor, :class_name => User
    end

    class Blog
      has_many :posts
    end

What we want to be able to express is that certain users are
- blog-admins: they can add authors, and can manage the entirety of the blog
- authors: they can manage their own posts (which they wrote), and they can manage the comments on their own posts
- commentators: they can read a blog, and create comments. They can only edit the comments they created

This should be expressable in our system ...

Therefore there are two concepts we introduce:

- the extent: which scopes the permission to certain contexts. A context is user-defined, in our case a blog.
  Permissions are only valid on certain blogs.
- the custom-rule: a rule that, using the context, can programmatically check whether certain conditions are met.
  In our case: an author can only edit posts he created would be such a check.

## Installation

First, add the `Vigilante` gem to your `Gemfile`:

    gem 'vigilante'

Then, do `bundle install`, and run the generator:

    rails g vigilante:install

This will add a configuration-file (so you edit it) and will add example glue code to the ApplicationController.
This will also add a number of needed migrations.

### What needs to be configured

For starters we need some kind of user-model. You can call it User, Operator, ...
But because the permissions will be specified (in the database), we need only one model (and no models based on
a role or permissions for the user). A user (operator, ...) just needs to be able to log on. Use Devise, Authlogic, or
roll your own. The Vigilante needs to know how the user model is called, and it needs to be able to reach the currently
logged on user.

Therefore, inside the `vigilante_config.yml` you can set the following two values:

- *current_user_method*: the method that needs to be called from within the controller context to retrieve the current user.
  If you are using Devise, this would be something like `current_<devise-model>`, e.g. `current_user` or `current_operator`.
-   


### To DO

- --> the operator 'permits' need to be added in a seperate method to the ActiveRecord:

    watched_by_vigilante

- improve documentation


## Copyright

Based on original code written by Bart Duchesne.
Copyright &copy; 2011 Nathan Van der Auwera, released under the MIT license
