require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Register::InitialsController do

  # This should return the minimal set of attributes required to create a valid
  # Register::Initial. As you add validations to Register::Initial, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Register::InitialsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all register_initials as @register_initials" do
      initial = Register::Initial.create! valid_attributes
      get :index, {}, valid_session
      assigns(:register_initials).should eq([initial])
    end
  end

  describe "GET show" do
    it "assigns the requested initial as @initial" do
      initial = Register::Initial.create! valid_attributes
      get :show, {:id => initial.to_param}, valid_session
      assigns(:initial).should eq(initial)
    end
  end

  describe "GET new" do
    it "assigns a new initial as @initial" do
      get :new, {}, valid_session
      assigns(:initial).should be_a_new(Register::Initial)
    end
  end

  describe "GET edit" do
    it "assigns the requested initial as @initial" do
      initial = Register::Initial.create! valid_attributes
      get :edit, {:id => initial.to_param}, valid_session
      assigns(:initial).should eq(initial)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Register::Initial" do
        expect {
          post :create, {:initial => valid_attributes}, valid_session
        }.to change(Register::Initial, :count).by(1)
      end

      it "assigns a newly created initial as @initial" do
        post :create, {:initial => valid_attributes}, valid_session
        assigns(:initial).should be_a(Register::Initial)
        assigns(:initial).should be_persisted
      end

      it "redirects to the created initial" do
        post :create, {:initial => valid_attributes}, valid_session
        response.should redirect_to(Register::Initial.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved initial as @initial" do
        # Trigger the behavior that occurs when invalid params are submitted
        Register::Initial.any_instance.stub(:save).and_return(false)
        post :create, {:initial => {}}, valid_session
        assigns(:initial).should be_a_new(Register::Initial)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Register::Initial.any_instance.stub(:save).and_return(false)
        post :create, {:initial => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested initial" do
        initial = Register::Initial.create! valid_attributes
        # Assuming there are no other register_initials in the database, this
        # specifies that the Register::Initial created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Register::Initial.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => initial.to_param, :initial => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested initial as @initial" do
        initial = Register::Initial.create! valid_attributes
        put :update, {:id => initial.to_param, :initial => valid_attributes}, valid_session
        assigns(:initial).should eq(initial)
      end

      it "redirects to the initial" do
        initial = Register::Initial.create! valid_attributes
        put :update, {:id => initial.to_param, :initial => valid_attributes}, valid_session
        response.should redirect_to(initial)
      end
    end

    describe "with invalid params" do
      it "assigns the initial as @initial" do
        initial = Register::Initial.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Register::Initial.any_instance.stub(:save).and_return(false)
        put :update, {:id => initial.to_param, :initial => {}}, valid_session
        assigns(:initial).should eq(initial)
      end

      it "re-renders the 'edit' template" do
        initial = Register::Initial.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Register::Initial.any_instance.stub(:save).and_return(false)
        put :update, {:id => initial.to_param, :initial => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested initial" do
      initial = Register::Initial.create! valid_attributes
      expect {
        delete :destroy, {:id => initial.to_param}, valid_session
      }.to change(Register::Initial, :count).by(-1)
    end

    it "redirects to the register_initials list" do
      initial = Register::Initial.create! valid_attributes
      delete :destroy, {:id => initial.to_param}, valid_session
      response.should redirect_to(register_initials_url)
    end
  end

end