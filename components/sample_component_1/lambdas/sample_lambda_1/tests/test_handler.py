import unittest
from components.sample_component_1.lambdas.sample_lambda_1.src.handler import lambda_handler

class TestHandler(unittest.TestCase):
    def test_lambda_handler(self):
        event = {"value": 5}
        context = {}
        response = lambda_handler(event, context)
        self.assertEqual(response["result"], 10)

if __name__ == "__main__":
    unittest.main()