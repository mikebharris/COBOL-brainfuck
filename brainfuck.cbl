identification division.
program-id. BrainfuckInterpreter.

environment division.
configuration section.
    repository.
        function all intrinsic.

input-output section.
file-control.
    select ProgramFile assign to ProgramFileName
        organization is sequential.

data division.
file section.
    fd ProgramFile.
    01 ProgramByte pic x.
        88 EndOfProgramFile value high-values.

working-storage section.
    01 ProgramToRun.
        02 Instruction pic x occurs 1 to 32768 times depending on ProgramLength values all spaces.
            88 IncrementDataPointer value ">".
            88 DecrementDataPointer value "<".
            88 IncrementByteAtDataPointer value "+".
            88 DecrementByteAtDataPointer value "-".
            88 OutputByteAtDataPointer value ".".
            88 InputByteAtDataPointer value ",".
            88 JumpIfByteIsZero value "[".
            88 JumpIfByteIsNonZero value "]".

    01 DataPointer pic 9(5).
    01 InstructionPointer pic 9(5).
    01 InputByte pic x value space.
    01 DataByteUpperBound constant 255.
    01 DataByteLowerBound constant -255.
    01 DataArray.
        02 DataByte pic S999 occurs 30000 times values all zeroes.
            88 UpperBoundReached value DataByteUpperBound.
            88 LowerBoundReached value DataByteLowerBound.
    01 CommandLineArgumentCount pic 9 value zero.
    01 ProgramLength pic 9(5) value zero.
    01 JumpCounter pic 999.

procedure division.

declaratives.
handle-errors section.
    use after standard error procedure on ProgramFile.
handle-error.
    display "Error opening or reading file"
    stop run.
end declaratives.

    accept CommandLineArgumentCount from argument-number
    if CommandLineArgumentCount equal to 1 then
        perform LoadProgramFromFile
    end-if

    move 1 to DataPointer
    move 1 to InstructionPointer

    perform with test after until InstructionPointer is greater than ProgramLength

        evaluate true
        when IncrementDataPointer(InstructionPointer)
            if DataPointer is less than 30000 then
                add 1 to DataPointer
            else
                move 1 to DataPointer
            end-if

        when DecrementDataPointer(InstructionPointer)
            if DataPointer is greater than 1 then
                subtract 1 from DataPointer
            else
                move 30000 to DataPointer
            end-if

        when IncrementByteAtDataPointer(InstructionPointer)
            if UpperBoundReached(DataByte(DataPointer)) then
                move DataByteLowerBound to DataByte(DataPointer)
            else
                add 1 to DataByte(DataPointer)
            end-if

        when DecrementByteAtDataPointer(InstructionPointer)
            if LowerBoundReached(DataByte(DataPointer)) then
                move DataByteUpperBound to DataByte(DataPointer)
            else
                subtract 1 from DataByte(DataPointer)
            end-if

        when OutputByteAtDataPointer(InstructionPointer)
            *> Note in COBOL ASCII codes start at 1 not 0
            display char(DataByte(DataPointer) + 1) with no advancing

        when InputByteAtDataPointer(InstructionPointer)
            accept InputByte
            *> Note in COBOL ASCII codes start at 1 not 0
            subtract 1 from ord(InputByte) giving DataByte(DataPointer)

        when JumpIfByteIsZero(InstructionPointer)
            if DataByte(DataPointer) is equal to zero then
                move 1 to JumpCounter
                perform until JumpCounter is equal to zero
                    add 1 to InstructionPointer
                    if JumpIfByteIsZero(InstructionPointer) then
                        add 1 to JumpCounter
                    end-if
                    if JumpIfByteIsNonZero(InstructionPointer) then
                        subtract 1 from JumpCounter
                    end-if
                end-perform
            end-if

        when JumpIfByteIsNonZero(InstructionPointer)
            if DataByte(DataPointer) is not equal to zero then
                move 1 to JumpCounter
                perform until JumpCounter is equal to zero
                    subtract 1 from InstructionPointer
                    if JumpIfByteIsNonZero(InstructionPointer) then
                        add 1 to JumpCounter
                    end-if
                    if JumpIfByteIsZero(InstructionPointer) then
                        subtract 1 from JumpCounter
                    end-if
                end-perform
            end-if

        end-evaluate

        add 1 to InstructionPointer

    end-perform

    stop run
    .

LoadProgramFromFile section.
    accept ProgramFileName from argument-value
    open input ProgramFile
    read ProgramFile next record
        at end set EndOfProgramFile to true
    end-read
    if not EndOfProgramFile then
        move zero to ProgramLength
        perform until EndOfProgramFile
            add 1 to ProgramLength
            move ProgramByte to Instruction(ProgramLength)
            read ProgramFile next record
                at end set EndOfProgramFile to true
            end-read
        end-perform
    end-if
    close ProgramFile
    display "Program loaded - length is " ProgramLength " bytes"
    .

end program BrainfuckInterpreter.
