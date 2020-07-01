# frozen_string_literal: true

module Rolify
  module Adapter
    class Base
      def initialize(role_cname, user_cname)
        @role_cname = role_cname
        @user_cname = user_cname
      end

      def role_class
        @role_cname.constantize
      end

      def user_class
        @user_cname.constantize
      end

      def role_table
        role_class.table_name
      end

      def self.create(adapter, role_cname, user_cname)
        load "rolify/adapters/#{Rolify.orm}/#{adapter}.rb"
        load "rolify/adapters/#{Rolify.orm}/scopes.rb"
        Rolify::Adapter.const_get(adapter.camelize.to_sym).new(role_cname, user_cname)
      end

      def relation_types_for(relation)
        relation.descendants.map(&:base_class).map(&:to_s).push(relation.to_s).uniq
      end
    end

    class RoleAdapterBase < Adapter::Base
      def where(_relation, _args)
        raise NotImplementedError, 'You must implement where'
      end

      def find_or_create_by(_role_name, _resource_type = nil, _resource_id = nil)
        raise NotImplementedError, 'You must implement find_or_create_by'
      end

      def add(_relation, _role_name, _resource = nil)
        raise NotImplementedError, 'You must implement add'
      end

      def remove(_relation, _role_name, _resource = nil)
        raise NotImplementedError, 'You must implement delete'
      end

      def exists?(_relation, _column)
        raise NotImplementedError, 'You must implement exists?'
      end
    end

    class ResourceAdapterBase < Adapter::Base
      def resources_find(_roles_table, _relation, _role_name)
        raise NotImplementedError, 'You must implement resources_find'
      end

      def in(_resources, _roles)
        raise NotImplementedError, 'You must implement in'
      end
    end
  end
end
