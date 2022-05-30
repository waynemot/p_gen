class PwTestsController < ApplicationController
  def index
    Rails.logger.info "pw_tests_ctlr"
    respond_to do |format|
      format.html {
        flash[:notice]="Html response to pw tests update"
        redirect_to passwords_path
      }
      format.js { render "passwords/_pw_test.js.erb"}
    end
  end
end
