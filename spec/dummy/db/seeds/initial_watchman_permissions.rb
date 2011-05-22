

perm_allowed_all = Permission.find_or_create_by_allowed_action('*[all]')
perm_read_all    = Permission.find_or_create_by_allowed_action('*[index,show]')
perm_blog_all     = Permission.find_or_create_by_allowed_action('blogs[all]')
perm_blog_read    = Permission.find_or_create_by_allowed_action('blogs[index,show]')

ab_all = Ability.find_or_create_by_name(:name => 'can-manage-all') do |ab|
  ab.permissions << perm_allowed_all
end

ab_read_all = Ability.find_or_create_by_name(:name => 'can-read-all') do |ab|
  ab.permissions << perm_read_all
end

ab_blog_all = Ability.find_or_create_by_name(:name => 'can-manage-blogs') do |ab|
  ab.permissions << perm_blog_all
end
ab_blog_all.update_attribute(:needs_extent, true)


ab_blog_read = Ability.find_or_create_by_name(:name => 'can-see-blogs') do |ab|
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