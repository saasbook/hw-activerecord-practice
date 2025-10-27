# frozen_string_literal: true

# -- Directories to listen on -------------------------------------------------
directories %w[submission lib spec].select { |d| Dir.exist?(d) }

# Restart Guard when the Guardfile itself changes
watch('Guardfile') do
  UI.info 'Guardfile changed — restarting Guard…'
  exit 0
end

# ---- RSpec ------------------------------------------------------------------
group :specs, halt_on_fail: true do
  # • failed_mode :keep   → keep re-running the failed spec list until it passes
  guard :rspec,
        cmd: 'bundle exec rspec --format documentation --color',
        failed_mode: :keep do
    require 'guard/rspec/dsl'
    dsl   = Guard::RSpec::Dsl.new(self)

    # RSpec helpers / support files
    rspec = dsl.rspec
    watch(rspec.spec_helper)  { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Implementation files — run matching specs
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)
    dsl.watch_spec_files_for('submission/**/*.rb')

    # Custom mapping: submission/foo.rb  → spec/foo_spec.rb
    watch(%r{^submission/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  end
end
