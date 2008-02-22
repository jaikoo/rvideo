require File.dirname(__FILE__) + '/../lib/rvideo'

def ffmpeg(key)
  f = YAML::load(File.open("#{FIXTURE_PATH}/ffmpeg_builds.yml"))
  return f[key.to_s]['response']
end

def files(key)
  f = YAML::load(File.open("#{FIXTURE_PATH}/files.yml"))
  return f[key.to_s]['response']
end

def recipes(key)
  f = YAML::load(File.open("#{FIXTURE_PATH}/recipes.yml"))
  return f[key.to_s]
end
