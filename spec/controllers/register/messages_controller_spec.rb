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

describe Register::MessagesController do

  # This should return the minimal set of attributes required to create a valid
  # Register::Message. As you add validations to Register::Message, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {  }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Register::MessagesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all register_messages as @register_messages" do
      message = Register::Message.create! valid_attributes
      get :index, {}, valid_session
      assigns(:register_messages).should eq([message])
    end
  end

  describe "GET show" do
    it "assigns the requested register_message as @register_message" do
      message = Register::Message.create! valid_attributes
      get :show, {:id => message.to_param}, valid_session
      assigns(:register_message).should eq(message)
    end
  end

  describe "GET new" do
    it "assigns a new register_message as @register_message" do
      get :new, {}, valid_session
      assigns(:register_message).should be_a_new(Register::Message)
    end
  end

  describe "GET edit" do
    it "assigns the requested register_message as @register_message" do
      message = Register::Message.create! valid_attributes
      get :edit, {:id => message.to_param}, valid_session
      assigns(:register_message).should eq(message)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Register::Message" do
        expect {
          post :create, {:register_message => valid_attributes}, valid_session
        }.to change(Register::Message, :count).by(1)
      end

      it "assigns a newly created register_message as @register_message" do
        post :create, {:register_message => valid_attributes}, valid_session
        assigns(:register_message).should be_a(Register::Message)
        assigns(:register_message).should be_persisted
      end

      it "redirects to the created register_message" do
        post :create, {:register_message => valid_attributes}, valid_session
        response.should redirect_to(Register::Message.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved register_message as @register_message" do
        # Trigger the behavior that occurs when invalid params are submitted
        Register::Message.any_instance.stub(:save).and_return(false)
        post :create, {:register_message => {  }}, valid_session
        assigns(:register_message).should be_a_new(Register::Message)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Register::Message.any_instance.stub(:save).and_return(false)
        post :create, {:register_message => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested register_message" do
        message = Register::Message.create! valid_attributes
        # Assuming there are no other register_messages in the database, this
        # specifies that the Register::Message created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Register::Message.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => message.to_param, :register_message => { "these" => "params" }}, valid_session
      end

      it "assigns the requested register_message as @register_message" do
        message = Register::Message.create! valid_attributes
        put :update, {:id => message.to_param, :register_message => valid_attributes}, valid_session
        assigns(:register_message).should eq(message)
      end

      it "redirects to the register_message" do
        message = Register::Message.create! valid_attributes
        put :update, {:id => message.to_param, :register_message => valid_attributes}, valid_session
        response.should redirect_to(message)
      end
    end

    describe "with invalid params" do
      it "assigns the register_message as @register_message" do
        message = Register::Message.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Register::Message.any_instance.stub(:save).and_return(false)
        put :update, {:id => message.to_param, :register_message => {  }}, valid_session
        assigns(:register_message).should eq(message)
      end

      it "re-renders the 'edit' template" do
        message = Register::Message.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Register::Message.any_instance.stub(:save).and_return(false)
        put :update, {:id => message.to_param, :register_message => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested register_message" do
      message = Register::Message.create! valid_attributes
      expect {
        delete :destroy, {:id => message.to_param}, valid_session
      }.to change(Register::Message, :count).by(-1)
    end

    it "redirects to the register_messages list" do
      message = Register::Message.create! valid_attributes
      delete :destroy, {:id => message.to_param}, valid_session
      response.should redirect_to(register_messages_url)
    end
  end

end
