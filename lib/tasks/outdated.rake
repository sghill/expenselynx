require 'rake'

OUTDATED_GEM_THRESHOLD = 10

namespace :gem do
  task :outdated do
    outdated_gems = %x[gem outdated].split("\n")
    if outdated_gems.size > OUTDATED_GEM_THRESHOLD
      abort """
Too many outdated gems (limit: #{OUTDATED_GEM_THRESHOLD}):
#{outdated_gems.map{|gem| "  #{gem}"}.join("\n")}
      """
    end
  end
end
