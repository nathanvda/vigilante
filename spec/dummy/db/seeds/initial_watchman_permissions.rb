

perm_allowed_all = Permission.where(allowed_action: '*[all]').first_or_create
perm_read_all    = Permission.where(allowed_action: '*[index,show]').first_or_create
perm_blog_all     = Permission.where(allowed_action: 'blogs[all]').first_or_create
perm_blog_read    = Permission.where(allowed_action: 'blogs[index,show]').first_or_create

ab_all = Ability.where(name: 'can-manage-all').first_or_create do |ab|
  ab.permissions << perm_allowed_all
end

ab_read_all = Ability.where(name: 'can-read-all').first_or_create do |ab|
  ab.permissions << perm_read_all
end

ab_blog_all = Ability.where(name: 'can-manage-blogs').first_or_create do |ab|
  ab.permissions << perm_blog_all
end
ab_blog_all.update_attribute(:needs_extent, true)


ab_blog_read = Ability.where(name: 'can-see-blogs').first_or_create do |ab|
  ab.permissions << perm_blog_read
end
ab_blog_read.update_attribute(:needs_extent, true)


### Assign the permissions to an operator/user
# If we have them

#op = Operator.find_by_email('admin@test.com')
#op.authorizations << Authorization.create(:operator_id => op.id, :ability_id => ab_all.id)
#
#op = Operator.find_by_email('blog_admin@test.com')
## can adminster blog with ids 1 and 2
#op.authorizations << Authorization.create(:operator_id => op.id, :ability_id => ab_all.id, :context => '1')
#op.authorizations << Authorization.create(:operator_id => op.id, :ability_id => ab_read_all.id, :context => '2')