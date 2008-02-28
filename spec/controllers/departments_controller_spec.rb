require File.dirname(__FILE__) + '/../spec_helper'

describe DepartmentsController, "#route_for" do

  it "should map { :controller => 'departments', :action => 'index' } to /departments" do
    route_for(:controller => "departments", :action => "index").should == "/departments"
  end
  
  it "should map { :controller => 'departments', :action => 'new' } to /portals/departments/new" do
    route_for(:controller => "departments", :action => "new").should == "/departments/new"
  end
  
  it "should map { :controller => 'departments', :action => 'show', :id => 1 } to /portals/departments/1" do
    route_for(:controller => "departments", :action => "show", :id => 1).should == "/departments/1"
  end
  
  it "should map { :controller => 'departments', :action => 'edit', :id => 1 } to /portals/departments/1/edit" do
    route_for(:controller => "departments", :action => "edit", :id => 1).should == "/departments/1/edit"
  end
  
  it "should map { :controller => 'departments', :action => 'update', :id => 1} to /portals/departments/1" do
    route_for(:controller => "departments", :action => "update", :id => 1).should == "/departments/1"
  end
  
  it "should map { :controller => 'departments', :action => 'destroy', :id => 1} to /portals/departments/1" do
    route_for(:controller => "departments", :action => "destroy", :id => 1).should == "/departments/1"
  end
  
end

describe DepartmentsController, "handling GET /departments" do

  before do
    @department = mock_model(Department)
    Department.stub!(:find).and_return([@department])
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all departments" do
    Department.should_receive(:find).with(:all).and_return([@department])
    do_get
  end
  
  it "should assign the found departments for the view" do
    do_get
    assigns[:departments].should == [@department]
  end
end

describe DepartmentsController, "handling GET /departments.xml" do

  before do
    @department = mock_model(Department, :to_xml => "XML")
    Department.stub!(:find).and_return(@department)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all departments" do
    Department.should_receive(:find).with(:all).and_return([@department])
    do_get
  end
  
  it "should render the found departments as xml" do
    @department.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe DepartmentsController, "handling GET /departments/1" do

  before do
    @department = mock_model(Department)
    Department.stub!(:find).and_return(@department)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the department requested" do
    Department.should_receive(:find).with("1").and_return(@department)
    do_get
  end
  
  it "should assign the found department for the view" do
    do_get
    assigns[:department].should equal(@department)
  end
end
#test
describe DepartmentsController, "handling GET /departments/1.xml" do

  before do
    @department = mock_model(Department, :to_xml => "XML")
    Department.stub!(:find).and_return(@department)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the department requested" do
    Department.should_receive(:find).with("1").and_return(@department)
    do_get
  end
  
  it "should render the found department as xml" do
    @department.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe DepartmentsController, "handling GET /departments/new" do

  before do
    @department = mock_model(Department)
    Department.stub!(:new).and_return(@department)
  end
  
  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create an new department" do
    Department.should_receive(:new).and_return(@department)
    do_get
  end
  
  it "should not save the new department" do
    @department.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new department for the view" do
    do_get
    assigns[:department].should equal(@department)
  end
end

describe DepartmentsController, "handling GET /departments/1/edit" do
  before do
    @department = mock_model(Department)
    Department.stub!(:find).and_return(@department)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
  
  it "should find the department requested" do
    Department.should_receive(:find).and_return(@department)
    do_get
  end
  
  it "should assign the found Department for the view" do
    do_get
    assigns[:department].should equal(@department)
  end
end

describe DepartmentsController, "handling POST /departments" do

  before do
    @department = mock_model(Department, :to_param => "1")

    Department.stub!(:new).and_return(@department)
  end
  
  def post_with_successful_save
    @department.should_receive(:save).and_return(true)
    post :create, :department => { }
  end
  
  def post_with_failed_save
    @department.should_receive(:save).and_return(false)
    post :create, :department => {}
  end
  
  it "should create a new department" do
    Department.should_receive(:new).with({}).and_return(@department)
    post_with_successful_save
  end

  it "should redirect to the new department on successful save" do
    post_with_successful_save
    response.should redirect_to(department_url(1))
  end

  it "should re-render 'new' on failed save" do
    post_with_failed_save
    response.should render_template('new')
  end
end

describe DepartmentsController, "handling PUT /departments/1" do

  before do
    @department = mock_model(Department, :to_param => "1")
    Department.stub!(:find).and_return(@department)
  end
  
  def put_with_successful_update
    @department.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1"
  end
  
  def put_with_failed_update
    @department.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1"
  end
  
  it "should find the department requested" do
    Department.should_receive(:find).with("1").and_return(@department)
    put_with_successful_update
  end

  it "should update the found department" do
    put_with_successful_update
    assigns(:department).should equal(@department)
  end

  it "should assign the found department for the view" do
    put_with_successful_update
    assigns(:department).should equal(@department)
  end

  it "should redirect to the department on successful update" do
    put_with_successful_update
    response.should redirect_to(department_url(1))
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe DepartmentsController, "handling DELETE /departments/1" do

  before do
    @department = mock_model(Department, :destroy => true)
    @department.stub!(:portal).and_return("MyPortal")
    Department.stub!(:find).and_return(@department)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the department requested" do
    Department.should_receive(:find).with("1").and_return(@department)
    do_delete
  end
  
  it "should call destroy on the found department" do
    @department.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the departments list" do
    do_delete
    response.should redirect_to(departments_url)
  end
end
