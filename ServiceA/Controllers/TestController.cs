using Microsoft.AspNetCore.Mvc;

namespace ServiceA.Controllers
{
    [ApiController]
    [Route("api")]
    public class TestController : ControllerBase
    {
        [HttpGet("hello")]
        public IActionResult GetHello()
        {
            return Ok(new { message = "This is Service A", timestamp = DateTime.UtcNow });
        }

        [HttpGet("info")]
        public IActionResult GetInfo()
        {
            return Ok(new { service = "ServiceA", version = "1.0", status = "running" });
        }
    }
}
