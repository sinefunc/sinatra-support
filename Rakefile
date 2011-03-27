task(:test) {
  Dir['./test/**/test_*.rb'].each { |f| load f }
}

task(:update_doc) {
  system "yard && cd doc && git add . && git add -u && git commit -m . && git push"
}
