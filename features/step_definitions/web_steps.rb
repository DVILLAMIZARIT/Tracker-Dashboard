require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

# Single-line step scoper
When /^(.*) within (.*[^:])$/ do |step, parent|
  with_scope(parent) { When step }
end

# Multi-line step scoper
When /^(.*) within (.*[^:]):$/ do |step, parent, table_or_string|
  with_scope(parent) { When "#{step}:", table_or_string }
end

Given /^(?:|Tracker )has a user "([^"]*)" with password "([^"]*)"$/ do |user,pass|

  FakeWeb.register_uri(:post,
                       "https://www.pivotaltracker.com/services/v3/tokens/active",
                       { :status => ["200", "OK"],
                         :content_type => 'text/xml',
                         :body => File.join('features', 'support', 'fixtures', 'tokens.xml') } )
end

Given /^(?:|user )"([^"]*)" is an admin$/ do |user|
  u = User.new
  u.username = user
  u.is_admin = true
  u.salt = "Some 32-digit secret string...."
  u.save
end

Given /^(?:|Tracker )has no user "([^"]*)" with password "([^"]*)"$/ do |user,pass|

  FakeWeb.register_uri(:post,
                       "https://www.pivotaltracker.com/services/v3/tokens/active",
                       { :status => ["401", "Unauthorized"],
                         :content_type => 'text/html',
                         :body => "Access Denied" } )
end

Given /^(?:|Tracker )has a project "([^"]*)"$/ do |project_name|
  FakeWeb.register_uri(:get,
                       "https://www.pivotaltracker.com/services/v3/projects",
                       { :status => ["200", "OK"],
                         :content_type => 'text/xml',
                         :body => File.join('features', 'support', 'fixtures', 'projects.xml') } )
  FakeWeb.register_uri(:get, 
                       "https://www.pivotaltracker.com/services/v3/projects/102622/stories",
                       { :status => ["200", "OK"],
                         :content_type => 'text/xml',
                         :body => File.join('features', 'support', 'fixtures', 'stories.xml') } )
  FakeWeb.register_uri(:get, 
                       "https://www.pivotaltracker.com/services/v3/projects/102622/iterations/current",
                       { :status => ["200", "OK"],
                         :content_type => 'text/xml',
                         :body => File.join('features', 'support', 'fixtures', 'iterations_current.xml') } ) # ???
  FakeWeb.register_uri(:get, 
                       "https://www.pivotaltracker.com/services/v3/projects/102622/iterations/backlog",
                       { :status => ["200", "OK"],
                         :content_type => 'text/xml',
                         :body => File.join('features', 'support', 'fixtures', 'iterations_backlog.xml') } ) # ???
end

When /^(?:|I )close the browser$/ do
end

When /^(?:|I )open the browser$/ do
end


Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  #click_link(link)
  find(:xpath, "//a[contains(text(), '#{link}')]").click
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|I )fill in "([^"]*)" for "([^"]*)"$/ do |value, field|
  fill_in(field, :with => value)
end

# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
When /^(?:|I )fill in the following:$/ do |fields|
  fields.rows_hash.each do |name, value|
    When %{I fill in "#{name}" with "#{value}"}
  end
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end

When /^(?:|I )select or add "([^"]*)" from "([^"]*)"$/ do |value, field|
  if !page.has_xpath?("//select[@name='#{field}']//option[@value='#{value}']")
    page.execute_script(" $('select[name=\"#{field}\"]').append('<option value=\"#{value}\">#{value}</option>'); ")  
  end
  select(value, :from => field)
end

When /^(?:|I )check "([^"]*)"$/ do |field|
  check(field)
end

When /^(?:|I )uncheck "([^"]*)"$/ do |field|
  uncheck(field)
end

When /^(?:|I )choose "([^"]*)"$/ do |field|
  choose(field)
end

When /^(?:|I )attach the file "([^"]*)" to "([^"]*)"$/ do |path, field|
  attach_file(field, File.expand_path(path))
end

When /^I wait until all Ajax requests are complete$/ do
  #wait_until do
  #  page.evaluate_script('$.active') == 0
  #end
  wait_until(3) do
    page.has_content?("Loading...") == false
  end
  #sleep 2
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /^(?:|I )should see "([^"]*)" snapshot[s]*$/ do |num|
  page.should have_css("select#list-of-snapshots option", :count => num.to_i)
end

Then /^(?:|I )should see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath('//*', :text => regexp)
  else
    assert page.has_xpath?('//*', :text => regexp)
  end
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_no_content(text)
  else
    assert page.has_no_content?(text)
  end
end

Then /^(?:|I )should not see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_no_xpath('//*', :text => regexp)
  else
    assert page.has_no_xpath?('//*', :text => regexp)
  end
end

Then /^(?:|I )should see a track named "([^"]*)"$/ do |name|
  page.find(:xpath, '//p[@class="track"][text()="'+name+'"]').text.should == name
end

Then /^(?:|I )should see a text input with value "([^"]*)"$/ do |value|
  page.find(:xpath, '//input[@value="'+value+'"]').value.should == value
end

Then /^"([^"]*)" should be selected for "([^"]*)"$/ do |value, field|
  page.find(:xpath, "//select[@name='#{field}']//option[@selected = 'selected']").value.should =~ /#{value}/
end

Then /^(?:|I )should see "([^"]*)" stories and "([^"]*)" points with "([^"]*)" status in the "([^"]*)" track$/ do |num_stories,num_points,story_status,track_name|
  page.find(:xpath, '//p[text()="'+track_name+'"]/../p[@class="'+story_status+'"]/span[@class="stories"]').text.should == num_stories
  page.find(:xpath, '//p[text()="'+track_name+'"]/../p[@class="'+story_status+'"]/span[@class="points"]' ).text.should == num_points
end

Then /^the "([^"]*)" field(?: within (.*))? should contain "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^"]*)" field(?: within (.*))? should not contain "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should_not
      field_value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^"]*)" checkbox(?: within (.*))? should be checked$/ do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_true
    else
      assert field_checked
    end
  end
end

Then /^the "([^"]*)" checkbox(?: within (.*))? should not be checked$/ do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_false
    else
      assert !field_checked
    end
  end
end
 
Then /^(?:|I )should be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then /^(?:|I )should have the following query string:$/ do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair{|k,v| expected_params[k] = v.split(',')} 
  
  if actual_params.respond_to? :should
    actual_params.should == expected_params
  else
    assert_equal expected_params, actual_params
  end
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^save the page$/ do
  puts page.driver.body
end

