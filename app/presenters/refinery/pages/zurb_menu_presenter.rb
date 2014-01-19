module Refinery
  module Pages
    class ZurbMenuPresenter < MenuPresenter

      config_accessor :list_dropdown_css, :list_item_dropdown_css, :list_tag_css

      self.menu_tag = nil
      self.dom_id = nil
      self.css = nil
      self.list_dropdown_css = 'dropdown'
      self.list_item_dropdown_css = 'has-dropdown'
      self.list_tag_css = nil
      self.selected_css = 'active'

      private

      def render_menu(items)
        if menu_tag
          content_tag(menu_tag, :id => dom_id, :class => css) do
            render_menu_items(items)
          end
        else
          render_menu_items(items)
        end
      end

      def render_menu_items(menu_items)
        return if menu_items.blank?
        content_tag(list_tag, :class => menu_items_css(menu_items)) do
          menu_items.each_with_index.inject(ActiveSupport::SafeBuffer.new) do |buffer, (item, index)|
            buffer << render_menu_item(item, index)
          end
        end
      end

      def check_for_dropdown_item(menu_item)
        ( menu_item != roots.first ) && ( menu_item_children( menu_item ).count > 0 )
      end

      def menu_items_css(menu_items)
        css = []

        if roots == menu_items
          css << list_tag_css
        else
          css << list_dropdown_css
        end

        css.reject(&:blank?).presence
      end

      def menu_item_css(menu_item, index)
        css = []

        css << selected_css if selected_item_or_descendant_item_selected?(menu_item)
        css << list_item_dropdown_css if check_for_dropdown_item(menu_item)
        css << first_css if index == 0
        css << last_css if index == menu_item.shown_siblings.length

        css.reject(&:blank?).presence
      end

      def render_menu_item(menu_item, index)
        content_tag(list_item_tag, :class => menu_item_css(menu_item, index)) do
          @cont = context.refinery.url_for(menu_item.url)
          buffer = ActiveSupport::SafeBuffer.new
          buffer << link_to(menu_item.title, context.refinery.url_for(menu_item.url))
          buffer << render_menu_items(menu_item_children(menu_item))
          buffer
        end
      end

    end
  end
end
