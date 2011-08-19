namespace :friendly_id do
	desc "Populate friendly_id slugs for existing records"
	task :make_slugs => :environment do
		# TODO: implement some sexy map code
		Person.all.map(&:save)
		Company.all.map(&:save)
		Group.all.map(&:save)
		Project.all.map(&:save)
	end
end