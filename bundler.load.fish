# The following is based on https://github.com/gma/bundler-exec

## Functions
function _bundler-installed
  which bundle >- ^&1
end

function _within-bundled-project
  set -l check_dir $PWD
  while [ $check_dir != "/" ]
    [ -f "$check_dir/Gemfile" ] and return
    set check_dir (dirname $check_dir)
  end
  false
end

function _run-with-bundler
  if _bundler-installed and _within-bundled-project
    command bundle exec $argv
  else
    $argv
  end
end

### Main program
set -l bundled_commands annotate cap capify cucumber foreman guard middleman nanoc rackup rainbows rake rspec ruby shotgun spec spinach spork thin thor unicorn unicorn_rails

for cmd in $bundled_commands
  if not contains $cmd bundle gem
    eval "function $cmd; _run-with-bundler $cmd \$argv; end"
  end
end
