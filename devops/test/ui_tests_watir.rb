# Test DBmaestro Using Watir
#  BJB 4/6/19
require 'rubygems'
require 'watir'
#require 'active_support/all'

@echo = true
@logged_in = false
@timestamp = Time.now.strftime("%Y%m%dT%H%M%S")
@temp_dir = File.dirname(File.expand_path(__FILE__))
@request_id = "0"
@test_log = ""

def init_log(run_name = "NewRun")
  @log_file = File.join(@temp_dir,"test_results_#{@timestamp}.txt")
  fil = File.open(@log_file,"w+")
  msg = "#-------------------------------------------------------------#\n"
  msg += "#  New Test Run: #{run_name}\n"
  msg += "#-------------------------------------------------------------#\n"
  msg += "Logging to: #{@log_file}"
  fil.puts msg
  puts msg if @echo
  fil.flush
  fil.close
end

def log(txt)
  fil = File.open(@log_file,"a")
  tstamp = Time.now.strftime("%H:%M:%S")
  txt.split("\n").each do |line|
    fil.puts "#{tstamp} | #{line}"
    puts "#{tstamp} | #{line}" if @echo
  end
  fil.flush
  fil.close
end

def test_login(user, password)
  @browser.goto @target_url
  log_msg = "Testing login screen (#{user}/<password>)"
  @browser.text_field(:name => "userName").set user
  @browser.text_field(:name => "password").set password
  sleep 2
  @browser.button(:value => "Login").click
  log log_msg
  raise "ERROR: failed login" if !@browser.title.include?("Dashboard")
  log_msg = "Directed to #{@browser.title}"
  @logged_in = true
  log log_msg
  true
end

def test_project
  sleep 2
  result = goto_item("project")
  log_msg = "Projects Screen: #{@browser.title}"
  log result
  sleep 2
  log log_msg
end

def test_package
  script_name = save_script_file("create_bbtable")
  result = goto_item("package")
  sleep 2
  package_name = "#{@test_details[:test_data][:package_name]}.#{@runid}"
  log_msg = "Packages Screen: #{@browser.title}"
  log log_msg
  log result
  result = goto_item("new_package")
  sleep 2
  log_msg = "Package: #{package_name}"
  log log_msg
  log result
  @browser.text_field("ng-model": "vm.data.packageName").set package_name
  @browser.button("ng-class": "button.klass").click
  log_msg = "Test Upload file (cancel)"
  log log_msg
  @browser.button(class: ["btn-default", "script-repository-add-script"]).click
  @browser.div("ng-model": "vm.data.files").click
  @browser.send_keys :escape
end

def test_steps(step_details)
  @browser.goto(File.join(@brpm_url,"requests" ,@request_id ,"edit"))
  sleep 2
  num_steps = step_details.size - 1
  @browser.link(:text => "New Step").when_present.click
  step_details.each_with_index do |step, idx|
    log "Creating step: #{step[:name]}"
    @browser.text_field(:id => "step_name").when_present.set step[:name]
    @browser.text_field(:id => "step_description").set step[:description] if step[:description]
    if step[:component_name]
      @browser.select_list(:id => "step_component_id").select step[:component_name]
      log "Selecting component: #{step[:component_name]}"
      if step[:automation_name]
        @browser.link(:text => "Automation", :href => "#").when_present.click
        log "Assiging automation: General-#{step[:automation_name]}"
        sleep 2
        @browser.select_list(:id => "automation_type").when_present.select "General"
        @browser.select_list(:id => "step_script_id").when_present.select step[:automation_name]
        sleep 2
        log "Setting automation arguments: #{step[:automation_argument_1]}"
        @browser.text_field(:id => /script_argument_/, :index => 0).when_present.set step[:automation_argument_1] if step[:automation_argument_1]
        @browser.text_field(:id => /script_argument_/, :index => 1).when_present.set step[:automation_argument_2] if step[:automation_argument_2]
        @browser.text_field(:id => /script_argument_/, :index => 2).when_present.set step[:automation_argument_3] if step[:automation_argument_3]
        @browser.text_field(:id => /script_argument_/, :index => 3).when_present.set step[:automation_argument_4] if step[:automation_argument_4]
      end
    end
    if idx == num_steps
      @browser.button(:value => "Add Step & Close").click
    else
      @browser.button(:value => "Add Step & Continue").click
    end
    sleep 2
  end
  log_regression_test("step_create", true, "Created steps in #{@request_id}")
  log_regression_test("step_assign_component", true, "Assigned step components in #{@request_id}")
  log_regression_test("step_assign_automation", true, "Assigned step automations")
  log_regression_test("step_assign_automation_arguments", true, "Assigned step automation arguments")
  
end

def test_reorder_steps
  log "Reordering Steps"
  @browser.goto(File.join(@brpm_url,"requests" ,@request_id ,"edit"))
  sleep 2
  @browser.link(:id => "reorder_steps").click
  sleep 2
  steps = @browser.divs(:id => /step_.*/)
  steps[1].drag_and_drop_on steps[0].parent
  log_regression_test("request_reorder_steps", true, "Reorder steps by drag and drop")
  @browser.goto(File.join(@brpm_url,"requests" ,@request_id ,"edit"))
end

def log_regression_test(test_name, result, details = "", script_name = "")
  if @test_log == ""
    @test_log = File.join(@temp_dir, @test_details[:test_data][:log_name])
    fil = File.open(@test_log, "w+")
    fil.puts "\tRegression Test Log - #{@test_details[:test_data][:name]}\t\t\t\t"
    fil.puts "Time\tResult\tTest Name\tdetails\tAutomation"
    fil.flush
    fil.close
  end
  verdict = result ? "Passed" : "Failed"
  fil = File.open(@test_log,"a")
  fil.puts "#{Time.now.strftime("%Y-%m-%dT%H:%M:%S")}\t#{verdict}\t#{test_name}\t#{details.gsub("\n","__lb__")}\t#{script_name}"
  fil.flush
  fil.close
  log details if details.length > 1
  @test_log
end

def goto_item(item_key)
  return "Failed" if !@test_details[:test_items].has_key?(item_key)
  item = @test_details[:test_items][item_key]
  xpath = item["xpath"]
  log "Testing #{item_key}"
  log "XPATH: #{xpath}"
  cur = @browser.element(:xpath => xpath)
  if cur.exists?
    begin
      if item.has_key?("action") && item["action"] == "double_click"
        cur.double_click
      else
        cur.click
      end
    rescue Exception => e
      return "Failed - #{e.message}"
    end
  else
    return "Failed - link doesnt exist"
  end
  return "Success"
end 

def save_script_file(script)
  name = @test_details[:automation][script][:name]
  fil = File.join(@test_details[:test_data][:staging_dir],name)
  #File.open(fil,"w+"){ |f|
  #  f.write(@test_details[:automation][script]["content"].gsub("_RUNID_", @runid))
  #}
  name
end

  #-------------------------------------------------------#
  #       MAIN ROUTINE
  #-------------------------------------------------------#

begin
  browser = :chrome
  @test_details = YAML.load_file(File.join(@temp_dir,"ui_tests.yml"))
  @target_url = @test_details[:test_data][:test_url]
  cur_run = ARGV[0] rescue nil
  cur_run = "NewRun" if cur_run.nil?
  @runid = @test_details[:test_data][:run_number]
  init_log(cur_run)
  log "Initializing #{browser.to_s}"
  @browser = Watir::Browser.new browser
  log "Using: #{@target_url}"
  test_login(@test_details[:test_data][:test_username], @test_details[:test_data][:test_password])
  @browser.driver.manage.window.maximize
  @test_details[:test_control].each do |test,do_it|
    self.send(test) if do_it
    sleep 2
  end

rescue Exception => e
  puts "#{e.message}\n#{e.backtrace}"
ensure
  at_exit { @browser.close if @browser }
end

