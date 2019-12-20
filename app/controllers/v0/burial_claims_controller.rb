# frozen_string_literal: true

module V0
  class BurialClaimsController < ClaimsBaseController
    def create
      PensionBurial::TagSentry.tag_sentry
      claim = claim_class.new(form: filtered_params[:form])
      unless claim.save
        StatsD.increment("#{stats_key}.failure")
        raise Common::Exceptions::ValidationErrors, claim
      end

      unless BipClaims::Service.new.create_claim(claim)
        claim.process_attachments! # upload claim and attachments to Central Mail if creation by API is not possible
      end

      # TODO: potentially separate out logs for creation of claims with Claims API vs Central Mail
      # and add veteran/claimant lookup failure
      StatsD.increment("#{stats_key}.success")
      Rails.logger.info "ClaimID=#{claim.confirmation_number} Form=#{claim.class::FORM}"
      validate_session
      clear_saved_form(claim.form_id)
      render(json: claim)
    end

    def short_name
      'burial_claim'
    end

    def claim_class
      SavedClaim::Burial
    end
  end
end
