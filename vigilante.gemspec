# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: vigilante 1.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "vigilante"
  s.version = "1.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Nathan Van der Auwera"]
  s.date = "2015-09-07"
  s.description = "Vigilante is a db-backed authorisation, completely configurable and dynamic; where permissions can be limited to extents."
  s.email = "nathan@dixis.com"
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    ".document",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "History.md",
    "MIT-LICENSE",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "app/controllers/abilities_controller.rb",
    "app/models/ability.rb",
    "app/models/ability_permission.rb",
    "app/models/authorization.rb",
    "app/models/authorization_extent.rb",
    "app/models/permission.rb",
    "app/models/permission_hash.rb",
    "app/views/abilities/_ability_permission_fields.html.haml",
    "app/views/abilities/_form.html.haml",
    "app/views/abilities/_permission_fields.html.haml",
    "app/views/abilities/edit.html.haml",
    "app/views/abilities/index.html.haml",
    "app/views/abilities/new.html.haml",
    "app/views/abilities/show.html.haml",
    "db/migrate/20150609151817_create_permissions.rb",
    "db/migrate/20150609151836_create_abilities.rb",
    "db/migrate/20150609151845_create_ability_permissions.rb",
    "db/migrate/20150609152056_create_authorizations.rb",
    "db/migrate/20150609152444_create_authorization_extents.rb",
    "lib/config/vigilante_config.yml",
    "lib/generators/vigilante/install/install_generator.rb",
    "lib/generators/vigilante/install/templates/vigilante_config.yml",
    "lib/vigilante.rb",
    "lib/vigilante/active_record_extensions.rb",
    "lib/vigilante/authorization.rb",
    "lib/vigilante/controller_extension.rb",
    "lib/vigilante/watched_operator.rb",
    "spec/controllers/application_controller_spec.rb",
    "spec/controllers/blogs_controller_spec.rb",
    "spec/dummy/Rakefile",
    "spec/dummy/app/controllers/application_controller.rb",
    "spec/dummy/app/controllers/blogs_controller.rb",
    "spec/dummy/app/helpers/application_helper.rb",
    "spec/dummy/app/models/author.rb",
    "spec/dummy/app/models/blog.rb",
    "spec/dummy/app/models/post.rb",
    "spec/dummy/app/views/layouts/application.html.erb",
    "spec/dummy/config.ru",
    "spec/dummy/config/application.rb",
    "spec/dummy/config/boot.rb",
    "spec/dummy/config/database.yml",
    "spec/dummy/config/environment.rb",
    "spec/dummy/config/environments/development.rb",
    "spec/dummy/config/environments/production.rb",
    "spec/dummy/config/environments/test.rb",
    "spec/dummy/config/initializers/backtrace_silencers.rb",
    "spec/dummy/config/initializers/inflections.rb",
    "spec/dummy/config/initializers/mime_types.rb",
    "spec/dummy/config/initializers/secret_token.rb",
    "spec/dummy/config/initializers/session_store.rb",
    "spec/dummy/config/locales/en.yml",
    "spec/dummy/config/routes.rb",
    "spec/dummy/config/vigilante_config.yml",
    "spec/dummy/db/migrate/20101028091755_create_permissions.rb",
    "spec/dummy/db/migrate/20101028091859_create_abilities.rb",
    "spec/dummy/db/migrate/20101028091927_create_ability_permissions.rb",
    "spec/dummy/db/migrate/20101028092014_create_authorizations.rb",
    "spec/dummy/db/migrate/20101124131334_add_extent_flag_to_ability.rb",
    "spec/dummy/db/migrate/20101129084538_add_authorization_extent.rb",
    "spec/dummy/db/migrate/20101129084620_remove_extent_from_authorization.rb",
    "spec/dummy/db/migrate/20110118120344_create_blogs.rb",
    "spec/dummy/db/migrate/20110118120421_create_posts.rb",
    "spec/dummy/db/migrate/20110118120448_create_authors.rb",
    "spec/dummy/db/schema.rb",
    "spec/dummy/db/seeds.rb",
    "spec/dummy/db/seeds/initial_watchman_permissions.rb",
    "spec/dummy/public/404.html",
    "spec/dummy/public/422.html",
    "spec/dummy/public/500.html",
    "spec/dummy/public/favicon.ico",
    "spec/dummy/public/javascripts/application.js",
    "spec/dummy/public/javascripts/controls.js",
    "spec/dummy/public/javascripts/dragdrop.js",
    "spec/dummy/public/javascripts/effects.js",
    "spec/dummy/public/javascripts/prototype.js",
    "spec/dummy/public/javascripts/rails.js",
    "spec/dummy/public/stylesheets/.gitkeep",
    "spec/dummy/script/rails",
    "spec/models/ability_permission_spec.rb",
    "spec/models/ability_spec.rb",
    "spec/models/author_spec.rb",
    "spec/models/authorization_extent_spec.rb",
    "spec/models/authorization_spec.rb",
    "spec/models/permission_hash_spec.rb",
    "spec/models/permission_spec.rb",
    "spec/spec_helper.rb",
    "spec/vigilante_spec.rb",
    "vigilante.gemspec"
  ]
  s.homepage = "http://github.com/vigilante"
  s.rubygems_version = "2.4.6"
  s.summary = "Context-based, db-backed authorisation for your rails3 apps"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 4.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.14.0"])
    else
      s.add_dependency(%q<rails>, [">= 4.0.0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.14.0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 4.0.0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.14.0"])
  end
end

