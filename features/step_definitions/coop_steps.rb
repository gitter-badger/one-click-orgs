def there_is_a_coop
  set_up_application_if_necessary

  @coop = @organisation = Coop.make!

  secretary = @coop.members.make!(:secretary)
  secretary_office = @coop.offices.make!(:title => "Secretary")
  secretary_office.officership = Officership.make!(:officer => secretary)

  @coop.members.make!(:director)

  set_subdomain_to_organisation
end

Given(/^there is a draft co\-op$/) do
  set_up_application_if_necessary

  @coop = @organisation = Coop.make!(:pending)

  founder = @coop.members.make!(:founder_member)

  set_subdomain_to_organisation
end

Given(/^there is a co\-op$/) do
  there_is_a_coop
end

Given(/^there is a Coop$/) do
  there_is_a_coop
end

Given(/^there is a Coop "(.*?)"$/) do |name|
  there_is_a_coop
  @coop.name = name
  @coop.save!
end

Given(/^our co\-op has been submitted for approval$/) do
  @coop ||= Coop.pending.last
  @coop.propose!
end

Given(/^the co\-op was founded a year ago$/) do
  @coop.clauses.where(ended_at: nil).update_all(started_at: 1.year.ago)
end

When(/^I enter my details$/) do
  fill_in("First name", :with => "Bob")
  fill_in("Last name", :with => "Smith")
  fill_in("Email address", :with => "bob@example.com")
  fill_in("Postal address", :with => "1 Main Street\nLondon\nN11 1AA")
  fill_in("Choose password", :with => "letmein")
  fill_in("Confirm password", :with => "letmein")
end

When(/^I enter the new co\-op's details$/) do
  fill_in("Co-op's official name", :with => "Coffee Ventures")
  fill_in("Your One Click Orgs web address will be", :with => "coffee")
  fill_in("coop_objectives", :with => "Selling coffee")
end

When(/^the co\-op daily job runs$/) do
  Coop.run_daily_job
end

When(/^the co\-op is approved$/) do
  @coop ||= Coop.proposed.last
  @coop.found!
end

When(/^a draft co\-op is created$/) do
  @coop = Coop.make!(:pending)
end

When(/^a draft co\-op is submitted for registration$/) do
  @coop = Coop.make!(:pending)
  @coop.propose!
end

When(/^I accept the Terms of Use$/) do
  check('I accept the Terms of Use.')
end
