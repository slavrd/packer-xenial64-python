control 'python3' do

  fpver = input('TEST_PVER')
  spver = fpver.split(/\.\d+\w*$/)[0]

  describe command("python#{spver}") do
    it { should exist }
  end

  describe command("python#{spver} --version") do
    its('stdout') { should eq "Python #{fpver}\n" }
  end

end
