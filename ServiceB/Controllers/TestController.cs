using Microsoft.AspNetCore.Mvc;

namespace ServiceB.Controllers
{
    [ApiController]
    [Route("api")]
    public class TestController : ControllerBase
    {
        [HttpGet("hello")]
        public IActionResult GetHello()
        {
            return Ok(new { message = "This is Service B", timestamp = DateTime.UtcNow });
        }

        [HttpGet("info")]
        public IActionResult GetInfo()
        {
            return Ok(new { service = "ServiceB", version = "1.0", status = "running" });
        }
    }
}
