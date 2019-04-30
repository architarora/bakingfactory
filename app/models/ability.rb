class Ability
  include CanCan::Ability

  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    
    # set authorizations for different user roles
    if user.role? :admin
      # they get to do it all
      can :manage, :all
      
    elsif user.role? :customer

      can :read, Item
      can :index, Item

      can :show, Order do |this_order|  
        my_orders = user.customer.orders.map(&:id)
        my_orders.include? this_order.id 
      end

      can :show, Customer do |this_customer|  
        user.customer == this_customer
      end

      can :update, Customer do |this_customer|  
        user.customer == this_customer
      end

      can :show, User do |u|  
        u.id == user.id
      end

      can :update, User do |u|  
        u.id == user.id
      end

      can :index, Order
      can :checkout, Order
      can :create, Order
      can :add_to_cart, Order
      can :add_to_cart, Item


      can :create, Address

      can :show, Address do |this_address|
        my_addresses = user.customer.addresses.map(&:id)  
        my_addresses.include? this_address.id
      end

      can :update, Address do |this_address|  
        my_addresses = user.customer.addresses.map(&:id)  
        my_addresses.include? this_address.id
      end

      can :index, Address

    elsif user.role? :baker

      can :show, Item
      can :index, Item

      can :index, Order
      can :baking_list, Order

    elsif user.role? :shipper

      can :show, Item
      can :index, Item

      can :show, Order
      can :index, Order

      can :show, Address
      
    else
      can :show, Item
      can :index, Item

      can :create, Customer
      can :new, Customer
    end
  end
end
