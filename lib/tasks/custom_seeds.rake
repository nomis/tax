# https://stackoverflow.com/a/56594383/388191

namespace :db do
  namespace :seed do

    SEEDS = Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort
    LOCAL_SEEDS = Dir[File.join(Rails.root, 'db', 'local', '*.rb')].sort
    ALL_SEEDS = SEEDS + LOCAL_SEEDS

    ALL_SEEDS.each do |filename|
      task_name = File.basename(filename, '.rb').intern

      task task_name => :environment do
        load(filename)
      end
    end

    task :all => :environment do
      SEEDS.each do |filename|
        load(filename)
      end

      LOCAL_SEEDS.each do |filename|
        load(filename)
      end
    end

  end
end
