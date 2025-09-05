# Dalxiis Tourism - Development Instructions

## 🗄️ **DATABASE CLEANUP COMPLETED**

### **Overview**
The database has been cleaned up to reflect the new system design. Unnecessary tables have been removed, and the schema has been updated to support the new dashboard requirements.

### **Tables Removed**
1. **`services`** - Not needed for new system design
2. **`admin_users`** - Redundant with profiles table
3. **`client_requests`** - Functionality merged into enhanced `bookings` table

### **Tables Kept (Essential for New System)**
1. **`profiles`** - User/admin authentication and role management
2. **`tour_packages`** - CMS for public packages page
3. **`destinations`** - CMS for public destinations page
4. **`bookings`** - Enhanced client booking form submissions
5. **`expenses`** - Financial operations management
6. **`income`** - Revenue tracking
7. **`financial_reports`** - Financial reports generation

### **Schema Updates**
- **`bookings` table enhanced** with:
  - `customer_name`, `customer_email`, `customer_phone` (direct customer info)
  - `destination_id` (support for destination-specific bookings)
  - `status` includes 'rejected' option
  - `assigned_to` (admin assignment for booking management)

### **Code Cleanup Completed**
- ✅ Removed all services-related code from `appStore.ts`
- ✅ Removed all services-related code from `dataService.ts`
- ✅ Updated database schema in `supabase.ts`
- ✅ Removed services hooks and actions
- ✅ Updated `initializeData()` method

## 📊 **NEW SYSTEM DESIGN - DASHBOARD REQUIREMENTS**

### **1. Overview Section**
- **Purpose**: Display key statistics and analytics from various system sections
- **Data Sources**: Aggregated data from bookings, packages, destinations, financial tables
- **Features**: Dashboard cards, charts, key performance indicators

### **2. Booking Management**
- **Purpose**: Manage client bookings and requests
- **Features**:
  - Incoming client requests (approve, reject, reschedule)
  - Comprehensive booking management
  - Customer information management
  - Booking status tracking

### **3. Financial Management**
- **Purpose**: Handle complete financial operations
- **Features**:
  - Expenses (utility bills, payroll, accommodations, meals, services)
  - Income tracking
  - Financial report generation
  - Import/export functionality

### **4. Reports Section**
- **Purpose**: Generate comprehensive reports
- **Sub-tabs**:
  - Bookings reports
  - Client data reports
  - Financial reports (income statements, etc.)

### **5. Packages CMS**
- **Purpose**: Manage public tour packages
- **Features**: CRUD operations, image management, status management
- **Public Display**: Packages page shows dynamic content from this table

### **6. Destinations CMS**
- **Purpose**: Manage public destinations
- **Features**: CRUD operations, image management, region management
- **Public Display**: Destinations page shows dynamic content from this table

### **7. Settings**
- **Purpose**: System and user management
- **Features**: User roles, permissions, system configuration, auditing

## 🔧 **TECHNICAL IMPLEMENTATION NOTES**

### **Database Relationships**
- `bookings` references `tour_packages` and `destinations` (optional)
- `profiles` manages user authentication and roles
- Financial tables are independent for reporting flexibility

### **Public Pages Architecture**
- **Static Pages**: Home, About, Contact, Services (no database required)
- **Dynamic Pages**: Packages, Destinations (CMS-driven content)
- **Interactive**: Booking form (submits to `bookings` table)

### **Admin Access Control**
- Role-based access: `superadmin`, `admin`
- Admin users restricted to dashboard only
- Public users see all public pages

### **Data Flow**
1. Admin creates/updates packages and destinations via CMS
2. Public pages display dynamic content from database
3. Customers submit bookings via public form
4. Admins manage bookings, financial data, and generate reports

## 🚀 **NEXT STEPS**

### **Immediate Tasks**
1. **Create New Admin Dashboard** - Build the 7-section dashboard structure
2. **Implement Overview Section** - Statistics and analytics display
3. **Build Booking Management** - Complete booking workflow
4. **Develop Financial Management** - Enhanced financial operations

### **Development Guidelines**
- Use existing database schema (no more table changes needed)
- Leverage existing UI components where possible
- Maintain consistent design patterns
- Ensure responsive design for all sections
- Implement proper error handling and user feedback

### **Testing Requirements**
- Test all CRUD operations for each section
- Verify data relationships and constraints
- Test responsive design on various devices
- Validate admin role restrictions
- Test public page content updates

## 📝 **IMPORTANT NOTES**

- **No More Database Changes**: The current schema supports all new requirements
- **Code Cleanup Complete**: All old admin dashboard code has been removed
- **Fresh Start**: New dashboard will be built from scratch using clean architecture
- **Performance**: Optimize data loading and rendering for better user experience
- **Security**: Maintain proper role-based access control throughout

---

**Status**: Database cleanup completed, ready for new dashboard development
**Last Updated**: Current development session
**Next Phase**: Admin Dashboard Creation
