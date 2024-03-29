class JobResultController < ApplicationController
  def api_call(path_params)
    api_root = "http://api.lmiforall.org.uk/api/v1"
    JSON.parse(RestClient.get("#{api_root}/#{path_params}"))
  end

  def verdict
    # Get the SOC code for the particular job.
    soc_result = api_call("soc/search?q=#{$job_name.gsub(" ", "+")}")
    
    if soc_result[0]
      # Convert the UK SOC code to its US ONET code.
      onet_result = api_call("o-net/soc2onet/#{soc_result[0]['soc']}")['onetCodes'][0]['code']
    
      # Search the skills endpoint for the ONET code.
      preprocesed_onet_skills = api_call("o-net/skills/#{onet_result}")['scales'][0]['skills']
      # Push the ONET skills data into a hash for later processing.
      @onet_skills = Hash.new
      preprocesed_onet_skills.each do |os|
        @onet_skills[:name] = os['name']
        @onet_skills[:value] = os['value']
      end
      # Search the abilities endpoint for the ONET code.
      preprocessed_onet_abilities = api_call("o-net/abilities/#{onet_result}")['scales'][0]['abilities']
      # Push the ONET abilities data into a hash for later processing.
      @onet_abilities = Hash.new
      preprocessed_onet_abilities.each do |oa|
        @onet_abilities[:name] = oa['name']
        @onet_abilities[:value] = oa['value']
      end

      # Push the skills thesaurus results into an array.
      @skill_thesaurus_results = Array.new
      @onet_skills.each do |skill|
        # The BigHugeThesaurus API doesn't handle querying for
        # multiple words, so only use the first word.
        skills_thesaurus = Dinosaurus.lookup("#{skill.last.to_s.strip.split(/\s+/)[0]}")
        skills_thesaurus.synonyms.each do |synonym|
          @skill_thesaurus_results.push(synonym)
        end
        skills_thesaurus.related_terms.each do |related_term|
          @skill_thesaurus_results.push(related_term)
        end
      end

      # Push the abilities thesaurus results into an array.
      @ability_thesaurus_results = Array.new
      @onet_abilities.each do |ability|
        # The BigHugeThesaurus API doesn't handle querying for
        # multiple words, so only use the first word.
        abilities_thesaurus = Dinosaurus.lookup("#{ability.last.to_s.strip.split(/\s+/)[0]}")
        abilities_thesaurus.synonyms.each do |synonym|
          @ability_thesaurus_results.push(synonym)
        end
        abilities_thesaurus.related_terms.each do |related_term|
          @ability_thesaurus_results.push(related_term)
        end
      end

      # Match the user's experience to the job's requirements.
      @matches = Array.new
      @non_matches = Array.new
      User.find(current_user.id).skills.each do |possible_match|
        if @skill_thesaurus_results.include?(possible_match.name) || @ability_thesaurus_results.include?(possible_match.name)
          @matches.push(possible_match.name)
        else
          @non_matches.push(possible_match.name)
        end
      end

      # If the user has >= 5 skills matched, award him or her the job.
      if @matches.count >= 5
        job_pay_hours_averages(soc_result[0]['soc'])
        render :success
      else
        render :failure
      end
    else
      redirect_to job_search_path, alert: "Sorry, we couldn't find any data for that job."
    end
  end

  def job_pay_hours_averages(soc)
    @avg_pay = api_call("ashe/estimatePay?soc=#{soc}")['series'][0]['estpay']
    @avg_hours = api_call("ashe/estimateHours?soc=#{soc}")['series'][0]['hours']
    
    job_pay_gender_averages(soc)
  end

  def job_pay_gender_averages(soc)
    # Average weekly pay for the opposite gender of the current user.
    if UserDetail.find(current_user).gender == "m"
      @avg_opposite_gender_pay = api_call("ashe/estimatePay?soc=#{soc}&gender=2")['series'][0]['estpay']
    else
      @avg_opposite_gender_pay = api_call("ashe/estimatePay?soc=#{soc}&gender=1")['series'][0]['estpay']
    end
  end

  def success
  end
  
  def failure
  end
end
