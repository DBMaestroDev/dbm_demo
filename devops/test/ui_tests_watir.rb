# Test RPM4.6 Using Watir
#  BJB 4/6/15
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

def test_details_lookup(name)
  result = "Rally test not found"
  if @test_details[:test_cases].has_key?(name)
    result = @test_details[:test_cases][name]
  end
  result
end

def test_login(user, password)
  @browser.goto @target_url
  log_msg = "Testing login screen (#{user}/<password>)"
  @browser.text_field(:name => "userName").set user
  @browser.text_field(:name => "password").set password
  @browser.button(:value => "Login").click
  log_regression_test("login", true, log_msg)
  raise "ERROR: failed login" if !@browser.title.include?("Dashboard")
  log_msg = "Directed to #{@browser.title}"
  @logged_in = true
  log_regression_test("dashboard_display", true, log_msg)
  true
end

def test_applications(app_details)
  log_msg = "Testing Applications screen (#{app_details[:name]})"
  @browser.link(:text => "Applications").when_present.click
  if !@browser.title.include?("Applications")
    log "ERROR: No access to Applications"
    return false
  end
  @browser.link(:href => "/brpm/apps/new").when_present.click
  @browser.text_field(:id => "app_name").set app_details[:name]
  @browser.select_list(:id => "app_team_ids").select "[default]"
  @browser.button(:name => "commit").click
  sleep 2
  raise "ERROR: failed to Create application" if !@browser.title.include?(app_details[:name])
  log_regression_test("applciation_create", true, log_msg)
  log "Directed to #{@browser.title}"
  log "Creating components/environments"
  environments = app_details[:environments].map{|k| k[:name]}
  environments.each do |env|
    @browser.link(:id => "add_remove_application_environment").when_present.click
    sleep 2
    @browser.link(:text => "create new environment").when_present.click
    sleep 2
    @browser.text_field(:id => "new_environments__name").set env
    @browser.form(:class => "add_remove_eg").submit
    sleep 2
  end
  log_msg = "Created environments: #{environments.join(",")}"
  log_regression_test("environment_create", true, log_msg)
  
  components = environments = app_details[:components].map{|k| k[:name]}
  components.each do |comp|
    @browser.link(:id => "add_remove_application_component").when_present.click
    sleep 2
    @browser.link(:text => "create new component").when_present.click
    sleep 2
    @browser.text_field(:id => "new_components__name").set comp
    @browser.form(:class => "add_remove cssform").submit
    sleep 2
  end
  log_msg = "Created components: #{components.join(",")}"
  log_regression_test("component_create", true, log_msg)
  @browser.link(:text => "Copy All Components to All Environments").when_present.click
  if @browser.alert.exists?
    log "Confirming warning"
    @browser.alert.ok
  end
  log_msg = "Assign all components to all environments"
  log_regression_test("assign_all_components_to_all_environments", true, log_msg)
  log "Created #{app_details[:name]} successfully"
  true
end

def test_automations
  log = "Testing Automation"
  @browser.link(:text => "Environment").when_present.click
  @test_details[:test_data][:automation].each do |name, script|
    @browser.goto("#{@brpm_url}/environment/scripts/new")
    if !@browser.title.include?("Script")
      log "ERROR: No access to Automations"
      return false
    end
    new_name = "#{script[:name]}_#{@timestamp}"
    log_msg = "Automation: #{new_name}"
    @browser.select_list(:id => "script_automation_type").when_present.select script[:automation_type]
    sleep 2
    @browser.select_list(:id => "script_automation_category").when_present.select script[:automation_category]
    @browser.text_field(:id => "script_name").when_present.set new_name
    @browser.text_field(:id => "script_description").when_present.set "Description of #{new_name}"
    @browser.textarea(:id => "script_content").when_present.set script[:content]
    @browser.button(:value => "Add script").click
    sleep 2
    log_regression_test("automation_create", true, log_msg)
    @browser.text_field(:id => "key").when_present.set new_name
    @browser.button(:value => "Search").click
    log_regression_test("automation_search", true, "Searching for #{new_name}")
    @browser.link(:class => "state_transition_right").when_present.click
    log "Created automation: #{new_name}, type: #{script[:automation_type]}"
    log_regression_test("automation_state_change", true, "Changing #{new_name} to Pending state")
    @test_details[:test_data][:automation][name][:name] = new_name
  end
end

def test_requests(req_details)
  log_msg = "Testing Requests (#{req_details[:name]})"
  @browser.goto("#{@brpm_url}/requests/new")
  if !@browser.title.include?("Create")
    log "ERROR: No access to Create Request"
    return false
  end
  @browser.text_field(:id => "request_name").set req_details[:name]
  @browser.select_list(:id => "request_app_ids").select req_details[:app_name]
  sleep 2
  @browser.select_list(:id => "request_environment_id").when_present.select req_details[:environment_name]
  if req_details[:plan_name]
    @browser.select_list(:id => "request_plan_member_attributes_plan_id").when_present.select req_details[:plan_name] 
    @browser.select_list(:id => "request_plan_member_attributes_plan_stage_id").when_present.select req_details[:plan_stage_name]
    log_regression_test("request_create_with_plan", true, "Adding Plan - #{req_details[:plan_name]}:#{req_details[:plan_stage_name]}")
  end
  @browser.form(:id => "new_request").submit
  cur_title = @browser.title
  if !cur_title.include?(req_details[:name])
    log "ERROR: Failed to Create Request"
    return false
  end
  items = cur_title.scan(/Request\s.*\s-/)
  @request_id = items[0].gsub("Request","").gsub("-","").strip
  log_regression_test("request_create", true, "#{log_msg} - #{@request_id}")
end

def test_request_execute
  @browser.goto(File.join(@brpm_url,"requests" ,@request_id ,"edit"))
  sleep 2
  log_msg = "Running request: #{@request_id}"
  log log_msg
  log "Planned State"
  @browser.link(:href => "/brpm/requests/#{@request_id}/update_state/plan").when_present.click
  log_regression_test("request_planned_state", true, "#{log_msg} - Planned")
  log "Started State"
  @browser.link(:href => "/brpm/requests/#{@request_id}/update_state/start").when_present.click
  log_regression_test("request_started_state", true, "#{log_msg} - Started")
  sleep 10
  status = "none"
  10.times do |idx|
    status = @browser.div(:id => "request_status").text
    break if ["complete", "problem"].include?(status.downcase)
    sleep 15
  end
  result_status = status.downcase == "complete"  
  log_regression_test("request_run_automated", result_status, "#{log_msg} - Started: final state: #{status}")
  return true
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
    fil.puts "Time\tResult\tTest Name\tRally URL\tdetails\tAutomation"
    fil.flush
    fil.close
  end
  test_url = test_details_lookup(test_name)
  verdict = result ? "Passed" : "Failed"
  fil = File.open(@test_log,"a")
  fil.puts "#{Time.now.strftime("%Y-%m-%dT%H:%M:%S")}\t#{verdict}\t#{test_name}\t#{test_url}\t#{details.gsub("\n","__lb__")}\t#{script_name}"
  fil.flush
  fil.close
  log details if details.length > 1
  @test_log
end

def update_request_details(app_details)
  @test_details[:test_data][:request][:environment_name] = app_details[:environments][0][:name]
  @test_details[:test_data][:request][:app_name] = app_details[:name]
  @test_details[:test_data][:request][:steps].each_with_index do |step, idx|
    @test_details[:test_data][:request][:steps][idx][:component_name] = app_details[:components][0][:name]
    script = @test_details[:test_data][:request][:steps][idx][:automation_name]
    @test_details[:test_data][:request][:steps][idx][:automation_name] = @test_details[:test_data][:automation][script][:name]
  end
  log "Updated Request info:\n#{@test_details[:test_data][:request].inspect}"
end

#-------------------------------------------------------#
#       Seed Data

app_details = {
  :name => "new application_#{@timestamp}",
  :components => [
    {:name => "comp1_#{@timestamp}"},
    {:name => "comp2_#{@timestamp}"}
  ],
  :environments => [
    {:name => "env1_#{@timestamp}"},
    {:name => "env2_#{@timestamp}"}
  ]
}
 
  #-------------------------------------------------------#
  #       MAIN ROUTINE
  #-------------------------------------------------------#

begin
  browser = :chrome
  @test_details = YAML.load_file(File.join(@temp_dir,"ui_tests.yml"))
  @target_url = @test_details[:test_data][:test_url]
  cur_run = ARGV[0] rescue nil
  cur_run = "NewRun" if cur_run.nil?
  init_log(cur_run)
  log "Initializing #{browser.to_s}"
  @browser = Watir::Browser.new browser
  log "Using: #{@target_url}"
  test_login(@test_details[:test_data][:test_username], @test_details[:test_data][:test_password]) if @test_details[:test_control][:test_login]  
  @browser.driver.manage.window.maximize
rescue Exception => e
  puts "#{e.message}\n#{e.backtrace}"
ensure
  at_exit { @browser.close if @browser }
end

