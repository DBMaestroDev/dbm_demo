require 'rubygems'
require 'watir'
browser = :chrome
user = "dbmguest@dbmaestro.com"
password = "Trial123!"
@target_url = "dbmtemplate:88"
@browser = Watir::Browser.new browser

@browser.goto @target_url
@browser.text_field(:name => "userName").set user
@browser.text_field(:name => "password").set password
@browser.button(:value => "Login").click
xpath = "/html/body/app/main/div/div/div/ui-view/projects//div[@class='title-box-panel-header']"
/html/body/app/main/div/div/div/ui-view/projects//div[@class='title-box-panel-header']
cur = @browser.element(:xpath => xpath)
cur.attribute_value("project-id")
=> 16
if cur.exists?
  cur.double_click
end
xpath = "/html/body/app/main//a[@class='item-link ng-binding ng-scope ng-isolate-scope']"
cur = @browser.element(:xpath => xpath)
if cur.exists?
  cur.click
end

/html/body/app/main/div/div/div/ui-view/package-manager/packages/div/div[2]/packages-versions/div/div/div[3]

<button class="btn-default script-repository-add-script" ng-click="vm.onUploadFiles({data: vm.scriptList})">
            <span class="script-repository-add-script-text">Upload Files</span>
            <i class="fa fa fa-upload" aria-hidden="true"></i>
        </button>


