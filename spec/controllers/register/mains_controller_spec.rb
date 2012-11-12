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

describe Register::MainsController do

  # This should return the minimal set of attributes required to create a valid
  # Register::Main. As you add validations to Register::Main, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Register::MainsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all register_mains as @register_mains" do
      main = Register::Main.create! valid_attributes
      get :index, {}, valid_session
      assigns(:register_mains).should eq([main])
    end
  end

  describe "GET show" do
    it "assigns the requested main as @main" do
      main = Register::Main.create! valid_attributes
      get :show, {:id => main.to_param}, valid_session
      assigns(:main).should eq(main)
    end
  end

  describe "GET new" do
    it "assigns a new main as @main" do
      get :new, {}, valid_session
      assigns(:main).should be_a_new(Register::Main)
    end
  end

  describe "GET edit" do
    it "assigns the requested main as @main" do
      main = Register::Main.create! valid_attributes
      get :edit, {:id => main.to_param}, valid_session
      assigns(:main).should eq(main)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Register::Main" do
        expect {
          post :create, {:main => valid_attributes}, valid_session
        }.to change(Register::Main, :count).by(1)
      end

      it "assigns a newly created main as @main" do
        post :create, {:main => valid_attributes}, valid_session
        assigns(:main).should be_a(Register::Main)
        assigns(:main).should be_persisted
      end

      it "redirects to the created main" do
        post :create, {:main => valid_attributes}, valid_session
        response.should redirect_to(Register::Main.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved main as @main" do
        # Trigger the behavior that occurs when invalid params are submitted
        Register::Main.any_instance.stub(:save).and_return(false)
        post :create, {:main => {}}, valid_session
        assigns(:main).should be_a_new(Register::Main)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Register::Main.any_instance.stub(:save).and_return(false)
        post :create, {:main => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested main" do
        main = Register::Main.create! valid_attributes
        # Assuming there are no other register_mains in the database, this
        # specifies that the Register::Main created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Register::Main.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => main.to_param, :main => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested main as @main" do
        main = Register::Main.create! valid_attributes
        put :update, {:id => main.to_param, :main => valid_attributes}, valid_session
        assigns(:main).should eq(main)
      end

      it "redirects to the main" do
        main = Register::Main.create! valid_attributes
        put :update, {:id => main.to_param, :main => valid_attributes}, valid_session
        response.should redirect_to(main)
      end
    end

    describe "with invalid params" do
      it "assigns the main as @main" do
        main = Register::Main.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Register::Main.any_instance.stub(:save).and_return(false)
        put :update, {:id => main.to_param, :main => {}}, valid_session
        assigns(:main).should eq(main)
      end

      it "re-renders the 'edit' template" do
        main = Register::Main.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Register::Main.any_instance.stub(:save).and_return(false)
        put :update, {:id => main.to_param, :main => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested main" do
      main = Register::Main.create! valid_attributes
      expect {
        delete :destroy, {:id => main.to_param}, valid_session
      }.to change(Register::Main, :count).by(-1)
    end

    it "redirects to the register_mains list" do
      main = Register::Main.create! valid_attributes
      delete :destroy, {:id => main.to_param}, valid_session
      response.should redirect_to(register_mains_url)
    end
  end

end
