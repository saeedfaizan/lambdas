from components.sample_component_1.lambdas.sample_lambda_1.src.dummy_class import DummyClass


def lambda_handler(event, context):
    dummy = DummyClass(value=event.get("value", 0))
    result = dummy.value * 2
    return {"result": result}
