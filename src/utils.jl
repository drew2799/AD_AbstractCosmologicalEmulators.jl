function maximin_input(input, in_MinMax)
    result = @views @.  (input - in_MinMax[:,1]) ./ (in_MinMax[:,2] - in_MinMax[:,1])
    return result
end
@adjoint function maximin_input(input, in_MinMax)
    o = maximin_input(input, in_MinMax)
    function maximin_input_PB(ō)
        ī = ō ./ (in_MinMax[:,2] - in_MinMax[:,1])
        return  (ī,nothing)
    end
    return o, maximin_input_PB
end

function inv_maximin_output(output, out_MinMax)
    result = @views @. output .* (out_MinMax[:,2] - out_MinMax[:,1]) + out_MinMax[:,1]
    return result
end
@adjoint function inv_maximin_output(output, out_MinMax)
    i = inv_maximin_output(output, out_MinMax)
    function inv_maximin_output_PB(ī)
        ō = ī .* (ut_MinMax[:,2] - out_MinMax[:,1])
        return (ō, nothing)
    end
    return i, inv_maximin_output_PB
end

function get_emulator_description(input_dict::Dict)
    if haskey(input_dict, "parameters")
        println("The parameters the model has been trained are, in the following order: "*input_dict["parameters"]*".")
    else
        @warn "We do not know which parameters were included in the emulators training space. Use this trained emulator with caution!"
    end
    if haskey(input_dict, "author")
        println("The emulator has been trained by "*input_dict["author"]*".")
    end
    if haskey(input_dict, "author_email")
        println(input_dict["author"]*" email is "*input_dict["author_email"]*".")
    end
    if haskey(input_dict, "miscellanea")
        println(input_dict["miscellanea"])
    end
    return nothing
end

function get_emulator_description(emu::AbstractTrainedEmulators)
    try
        get_emulator_description(emu.Description["emulator_description"])
    catch
        @warn "No emulator description present!"
    end

end
