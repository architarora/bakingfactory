class CustomersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  # before_action :check_login
  authorize_resource
  
  def index
    @active_customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @previous_orders = @customer.orders.chronological
  end

  def new
    @customer = Customer.new
    user = @customer.build_user
  end

  def edit
    # reformat phone w/ dashes when displayed for editing (preference; not required)
    @customer.phone = number_to_phone(@customer.phone)
  end

  def create
    @customer = Customer.new(customer_params)
    user = @customer.build_user
    user_hash = customer_params.to_h
    # @user = User.new(customer_params[:users_attributes])
    if current_user.nil?
      @customer.user.role = "customer"
      @customer.active = "true"
    end

    @customer.user.active = "true"
    @customer.user.username = user_hash['user_attributes']['username']
    @customer.user.password = user_hash['user_attributes']['password']
    @customer.user.password_confirmation = user_hash['user_attributes']['password_confirmation']
    # @customer.user.role = user_hash['user_attributes']['role']

    if @customer.save
        flash[:notice] = "Successfully created account. Please login below."
        redirect_to login_path
    else
        render action: 'new'
    end 
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "#{@customer.proper_name} was revised in the system."
    else
      render action: 'edit', notice: "Please fix errors below."
    end
  end

   def admin_dashboard
    @all_orders = Order.all
    @all_items = Item.all
    @all_customers = Customer.all
    @all_oi = OrderItem.all
    @sample_data = [1,2,3,4,5].to_a
  end

  def cust_dashboard
    @previous_orders = current_user.customer.orders
    @previous_items = current_user.customer.orders.map {|a| a.order_items.map {|l| l.item}}.last(10)
    @best_sellers = Item.all.last(5)
  end

  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active, user_attributes: [:username, :password, :password_confirmation, :role])
  end

end