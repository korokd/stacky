import gleeunit
import gleeunit/should
import stacky.{
  ErlangFileName, ErlangLineNumber, ErlangModuleName, FunctionArity,
  FunctionName, StackFrame, StackIndex, StackTrace,
}

pub fn main() {
  gleeunit.main()
}

const erlang_file_name = "stacky/build/dev/erlang/stacky/_gleam_artefacts/stacky_test.erl"

pub fn stacky_test() {
  let expected_trace =
    StackTrace("Trace", [
      StackFrame(
        StackIndex(6),
        ErlangModuleName("stacky_test"),
        FunctionName("stacky_test"),
        FunctionArity(0),
        ErlangFileName(
          "stacky/build/dev/erlang/stacky/_gleam_artefacts/stacky_test.erl",
        ),
        ErlangLineNumber(65),
      ),
      StackFrame(
        StackIndex(5),
        ErlangModuleName("eunit_test"),
        FunctionName("-mf_wrapper/2-fun-0-"),
        FunctionArity(2),
        ErlangFileName("eunit_test.erl"),
        ErlangLineNumber(274),
      ),
      StackFrame(
        StackIndex(4),
        ErlangModuleName("eunit_test"),
        FunctionName("run_testfun"),
        FunctionArity(1),
        ErlangFileName("eunit_test.erl"),
        ErlangLineNumber(72),
      ),
      StackFrame(
        StackIndex(3),
        ErlangModuleName("eunit_proc"),
        FunctionName("run_test"),
        FunctionArity(1),
        ErlangFileName("eunit_proc.erl"),
        ErlangLineNumber(544),
      ),
      StackFrame(
        StackIndex(2),
        ErlangModuleName("eunit_proc"),
        FunctionName("with_timeout"),
        FunctionArity(3),
        ErlangFileName("eunit_proc.erl"),
        ErlangLineNumber(369),
      ),
      StackFrame(
        StackIndex(1),
        ErlangModuleName("eunit_proc"),
        FunctionName("handle_test"),
        FunctionArity(2),
        ErlangFileName("eunit_proc.erl"),
        ErlangLineNumber(527),
      ),
    ])

  let expected_frame =
    StackFrame(
      StackIndex(6),
      ErlangModuleName("stacky_test"),
      FunctionName("stacky_test"),
      FunctionArity(0),
      ErlangFileName(erlang_file_name),
      ErlangLineNumber(65),
    )

  // The ErlangFileName is relative to wherever this test runs so we need to replace it
  let stack_trace = stacky.trace()
  let assert StackTrace(reason: reason, frames: [head_frame, ..frames]) =
    stack_trace
  let head_frame =
    StackFrame(..head_frame, erlang_file_name: ErlangFileName(erlang_file_name))
  let stack_trace = StackTrace(reason: reason, frames: [head_frame, ..frames])

  let stack_frame =
    stack_trace
    |> stacky.frame(0)

  let gleam_module_name =
    stack_frame
    |> stacky.qualified_module_name

  stack_trace
  |> should.equal(expected_trace)

  stack_frame
  |> should.equal(expected_frame)

  gleam_module_name
  |> should.equal("stacky_test")
}
