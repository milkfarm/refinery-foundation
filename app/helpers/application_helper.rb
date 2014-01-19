module ApplicationHelper

  # Creates a dropdown menu with items matching Refinery pages
  # and tags/css matching Foundation markup
  #
  # Options:
  # * +:menu_tag+ - A wrapper for the lists
  # * +:dom_id+ - The dom id for the wrapper
  # * +:css+ - The css class for the wrapper
  # * +:list_dropdown_css+ - The css class of the submenu list
  # * +:list_item_dropdown_css+ - The css class of the main menu item that has a dropdown
  # * +:list_tag_css+ - The css class of the main menu
  # * +:selected_css+ - The css class denoting a selected/active menu item
  def zurb_menu(items, options = {})
    presenter = Refinery::Pages::ZurbMenuPresenter.new(items, self)
    %w(menu_tag dom_id css list_dropdown_css list_item_dropdown_css list_tag_css selected_css).map(&:to_sym).each do |k|
      presenter.send("#{k}=", options[k]) if options.has_key?(k)
    end
    presenter
  end

end
